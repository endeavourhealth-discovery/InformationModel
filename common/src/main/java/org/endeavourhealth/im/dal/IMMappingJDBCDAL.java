package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.logic.MappingLogic;
import org.endeavourhealth.im.models.mapping.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public class IMMappingJDBCDAL implements IMMappingDAL {
    private final Connection conn;

    private final String GENERATED_SCHEME = "CM_DiscoveryCode";

    private static boolean hasValue(String s) {
        return (s != null && !s.isEmpty());
    }

    public IMMappingJDBCDAL()  {
        this.conn = ConnectionPool.getInstance().pop();
    }

    @Override
    public MapNode getNode(String provider, String system, String schema, String table, String column) throws SQLException {
        List<String> join = new ArrayList<>();
        List<String> where = new ArrayList<>();

        if (hasValue(provider)) {
            join.add("JOIN concept prv ON prv.dbid = m.provider");
            where.add("prv.id = ?");
        }

        if (hasValue(system)) {
            join.add("JOIN concept sys ON sys.dbid = m.`system`");
            where.add("sys.id = ?");
        }

        if (hasValue(schema))
            where.add("m.`schema` = ?");

        if (hasValue(table))
            where.add("m.`table` = ?");

        if (hasValue(column))
            where.add("m.`column` = ?");

        String sql = "SELECT n.id, n.node\n" +
            "FROM map_context m\n" +
            "JOIN map_node n ON n.id = m.node\n" +
            String.join("\n", join) + "\n" +
            "WHERE " + String.join("\nAND ", where);

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 0;
            if (hasValue(provider)) stmt.setString(++i, provider);
            if (hasValue(system)) stmt.setString(++i, system);
            if (hasValue(schema)) stmt.setString(++i, schema);
            if (hasValue(table)) stmt.setString(++i, table);
            if (hasValue(column)) stmt.setString(++i, column);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new MapNode(rs.getInt("id"), rs.getString("node"));
                else
                    return null;
            }
        }
    }

    @Override
    public ConceptIdentifiers getNodePropertyConcept(String node) throws SQLException {
        String sql = "SELECT c.dbid, c.id, c.code, s.id AS scheme\n" +
            "FROM map_node m\n" +
            "JOIN concept c ON c.dbid = m.concept\n" +
            "LEFT JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE m.node = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, node);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new ConceptIdentifiers()
                        .setDbid(rs.getInt("dbid"))
                        .setIri(rs.getString("id"))
                        .setCode(rs.getString("code"))
                        .setScheme(rs.getString("scheme"));
                else
                    return null;
            }
        }
    }

    @Override
    public MapResponse createNodePropertyConcept(String provider, String system, String schema, String table, String column) throws SQLException {
        List<String> ids = new ArrayList<>();
        if (hasValue(provider)) ids.add(provider);
        if (hasValue(system)) ids.add(system);
        if (hasValue(schema)) ids.add(schema);
        if (hasValue(table)) ids.add(table);
        if (hasValue(column)) ids.add(column);

        // Generate a full context string
        String context = "/" + String.join("/", ids);

        conn.setAutoCommit(false);
        try {
            // ******************** Legacy property concept ********************
            // Use temp (unique) IRI to generate/allocate a dbid
            String iri = UUID.randomUUID().toString();

            int cptId = createConcept(iri, "Legacy mapping property ", "Legacy mapping property for " + context, iri, GENERATED_SCHEME);

            iri = ids.stream().map(MappingLogic::getShortString).collect(Collectors.joining("_")) + "_" + cptId;

            // Update with final IRI
            String sql = "UPDATE concept SET id = ?, code = ? WHERE dbid = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, "LP_" + iri);
                stmt.setString(2, iri);
                stmt.setInt(3, cptId);
                if (stmt.executeUpdate() != 1)
                    throw new IllegalStateException("Unable to update temporary legacy mapping property [" + cptId + "] ==> [" + iri + "]");
            }

            // ******************** Mapping node ********************
            // Create node
            sql = "INSERT INTO map_node (node, concept) VALUES (?, ?)";
            String node = UUID.randomUUID().toString();
            int nodeId;
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, node);
                stmt.setInt(2, cptId);
                if (stmt.executeUpdate() != 1)
                    throw new IllegalStateException("Unable to create map node [" + node + "] ==> [" + cptId + "]");

                nodeId = DALHelper.getGeneratedKey(stmt);
            }

            node = "/" + ids.stream().map(MappingLogic::getShortString).collect(Collectors.joining("/")) + "/" + nodeId;
            sql = "UPDATE map_node SET node = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, node);
                stmt.setInt(2, nodeId);

                if (stmt.executeUpdate() != 1)
                    throw new IllegalStateException("Unable to update temporary node [" + nodeId + "] ==> [" + node + "]");
            }

            // ******************** Mapping context ********************
            // Check context
            ConceptIdentifiers prv = getConcept(provider);
            int prvId = (prv != null) ? prv.getDbid() : createConcept(provider, "Context organisation", "Auto generated map context organistion", provider, GENERATED_SCHEME);

            ConceptIdentifiers sys = getConcept(system);
            int sysId = (sys != null) ? sys.getDbid() : createConcept(system, "Context system", "Auto generated map context system", system, GENERATED_SCHEME);

            // Create context map to node
            sql = "INSERT INTO map_context (provider, `system`, `schema`, `table`, `column`, node)\n" +
                "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                int i = 0;
                DALHelper.setInt(stmt, ++i, prvId);
                DALHelper.setInt(stmt, ++i, sysId);
                DALHelper.setString(stmt, ++i, schema);
                DALHelper.setString(stmt, ++i, table);
                DALHelper.setString(stmt, ++i, column);
                DALHelper.setInt(stmt, ++i, nodeId);

                if (stmt.executeUpdate() != 1)
                    throw new IllegalStateException("Unable to create context");
            }

            conn.commit();

            return new MapResponse()
                .setNode(new MapNode(nodeId, node))
                .setConcept(
                    new ConceptIdentifiers()
                        .setDbid(cptId)
                        .setIri("LP_" + iri)
                        .setCode(iri)
                        .setScheme(GENERATED_SCHEME)
                );
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    @Override
    public MapValueNode getValueNode(String node, String scheme) throws SQLException {
        String sql = "SELECT v.id, v.function\n" +
            "FROM map_value_node v\n" +
            "JOIN map_node n ON n.id = v.node AND n.node = ?\n";

        if (scheme == null || scheme.isEmpty()) {
            sql += "WHERE v.code_scheme IS NULL\n";
        } else {
            sql += "JOIN concept s ON s.dbid = v.code_scheme AND s.id = ?\n";
        }

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, node);
            if (hasValue(scheme))
                stmt.setString(2, scheme);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new MapValueNode(rs.getInt("id"), scheme, rs.getString("function"));
                else
                    return null;
            }
        }
    }

    @Override
    public MapValueNode createValueNode(String node, String codeScheme) throws SQLException {
        String sql = hasValue(codeScheme)
            ? "INSERT INTO map_value_node\n" +
            "(node, code_scheme)\n" +
            "SELECT n.id, s.dbid\n" +
            "FROM map_node n\n" +
            "JOIN concept s\n" +
            "WHERE n.node = ?\n" +
            "AND s.id = ?"
            : "INSERT INTO map_value_node\n" +
            "(node, code_scheme)\n" +
            "SELECT n.id, null\n" +
            "FROM map_node n\n" +
            "WHERE n.node = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, node);
            if (hasValue(codeScheme))
                stmt.setString(2, codeScheme);

            if (stmt.executeUpdate() != 1)
                throw new IllegalStateException("Unable to create value node for node [" + node + "], scheme [" + codeScheme + "]");

            return new MapValueNode(DALHelper.getGeneratedKey(stmt), codeScheme, "Lookup()");
        }
    }


    @Override
    public ConceptIdentifiers getValueNodeConcept(MapValueNode valueNode, MapValueRequest value) throws SQLException {
        String sql = "SELECT c.dbid, c.id, c.code, s.id AS scheme\n" +
            "FROM map_value_node_lookup v\n" +
            "JOIN concept c ON c.dbid = v.concept\n" +
            "LEFT JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE v.value_node = ?\n" +
            "AND v.value = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, valueNode.getId());
            if (hasValue(value.getCode()))
                stmt.setString(2, value.getCode());
            else
                stmt.setString(2, value.getTerm());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new ConceptIdentifiers()
                        .setDbid(rs.getInt("dbid"))
                        .setIri(rs.getString("id"))
                        .setCode(rs.getString("code"))
                        .setScheme(rs.getString("scheme"));
                else
                    return null;
            }
        }
    }

    @Override
    public ConceptIdentifiers createValueNodeConcept(MapValueNode valueNode, String provider, String system, String schema, String table, String column, MapValueRequest value) throws SQLException {
        conn.setAutoCommit(false);
        try {
            ConceptIdentifiers result = createLegacyPropertyValueConcept(provider, system, schema, table, column, value);

            String sql = "INSERT INTO map_value_node_lookup\n" +
                "(value_node, value, concept)\n" +
                "VALUES\n" +
                "(?, ?, ?)\n";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                int i = 0;
                stmt.setInt(++i, valueNode.getId());
                if (hasValue(value.getCode()))
                    stmt.setString(++i, value.getCode());
                else
                    stmt.setString(++i, value.getTerm());

                stmt.setInt(++i, result.getDbid());

                if (stmt.executeUpdate() != 1)
                    throw new IllegalStateException("Unable to create node value");
            }

            conn.commit();

            return result;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    @Override
    public ConceptIdentifiers getConceptIdentifiers(String iri) throws SQLException {
        String sql = "SELECT c.dbid, c.code, s.id AS scheme\n" +
            "FROM concept c\n" +
            "LEFT JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE c.id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, iri);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new ConceptIdentifiers()
                    .setDbid(rs.getInt("dbid"))
                    .setIri(iri)
                    .setCode(rs.getString("code"))
                    .setScheme(rs.getString("scheme"));
                else
                    return null;
            }
        }
    }

    @Override
    public ConceptIdentifiers createLegacyPropertyValueConcept(String provider, String system, String schema, String table, String column, MapValueRequest value) throws SQLException {
        List<String> ids = new ArrayList<>();
        if (hasValue(provider)) ids.add(provider);
        if (hasValue(system)) ids.add(system);
        if (hasValue(schema)) ids.add(schema);
        if (hasValue(table)) ids.add(table);
        if (hasValue(column)) ids.add(column);
        if (hasValue(value.getCode())) ids.add(value.getCode());
        if (hasValue(value.getScheme())) ids.add(value.getScheme());
        if (hasValue(value.getTerm())) ids.add(value.getTerm());

        // Generate a full context string
        String context = "/" + String.join("/", ids);

        String iri = UUID.randomUUID().toString();

        int cptId = createConcept(iri, "Legacy mapping property value", "Legacy mapping property value for " + context, iri, GENERATED_SCHEME);
        String code = ids.stream().map(MappingLogic::getShortString).collect(Collectors.joining("_")) + "_" + cptId;
        iri = "LPV_" + code;

        // Update with final IRI
        String sql = "UPDATE concept SET id = ?, code = ? WHERE dbid = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, iri);
            stmt.setString(2, code);
            stmt.setInt(3, cptId);
            if (stmt.executeUpdate() != 1)
                throw new IllegalStateException("Unable to update temporary legacy mapping property value [" + cptId + "] ==> [" + iri + "]");
        }

        return new ConceptIdentifiers()
            .setDbid(cptId)
            .setIri(iri)
            .setCode(code)
            .setScheme(GENERATED_SCHEME);
    }

    @Override
    public ConceptIdentifiers createFormattedValueNodeConcept(String provider, String system, String schema, String table, String column, MapValueRequest value, String iri) throws Exception {
        List<String> ids = new ArrayList<>();
        if (hasValue(provider)) ids.add(provider);
        if (hasValue(system)) ids.add(system);
        if (hasValue(schema)) ids.add(schema);
        if (hasValue(table)) ids.add(table);
        if (hasValue(column)) ids.add(column);
        if (hasValue(value.getCode())) ids.add(value.getCode());
        if (hasValue(value.getScheme())) ids.add(value.getScheme());
        if (hasValue(value.getTerm())) ids.add(value.getTerm());

        // Generate a full context string
        String context = "/" + String.join("/", ids);

        int cptId = createConcept(iri, "Legacy mapping property value", "Legacy mapping property value for " + context, value.getCode(), value.getScheme());

        return new ConceptIdentifiers()
            .setDbid(cptId)
            .setIri(iri)
            .setCode(value.getCode())
            .setScheme(value.getScheme());
    }

    private ConceptIdentifiers getNodeConcept(String node) throws SQLException {
        String sql = "SELECT c.dbid, c.id, c.code, s.id AS scheme\n" +
            "FROM map_node m\n" +
            "JOIN concept c ON c.dbid = m.concept\n" +
            "LEFT JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE m.node = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, node);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new ConceptIdentifiers()
                        .setDbid(rs.getInt("dbid"))
                        .setIri(rs.getString("id"))
                        .setCode(rs.getString("code"))
                        .setScheme(rs.getString("scheme"));
                else
                    return null;
            }
        }
    }

    private ConceptIdentifiers getConcept(String conceptIri) throws SQLException {
        String sql = "SELECT c.dbid, c.id, c.code, s.id AS scheme\n" +
            "FROM concept c\n" +
            "LEFT JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE c.id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, conceptIri);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new ConceptIdentifiers()
                    .setDbid(rs.getInt("dbid"))
                    .setIri(rs.getString("id"))
                    .setCode(rs.getString("code"))
                    .setScheme(rs.getString("scheme"));
                else
                    return null;
            }
        }

    }

    private int createConcept(String conceptIri, String name, String description, String code, String scheme) throws SQLException {
        String sql = !hasValue(scheme)
            ? "INSERT INTO concept (id, name, description, draft, document) VALUES (?, ?, ?, true, 1)"
            : "INSERT INTO concept (id, name, description, draft, document, code, scheme)\n" +
            "SELECT ?, ?, ?, true, 1, ?, s.dbid\n" +
            "FROM concept s\n" +
            "WHERE s.id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            DALHelper.setString(stmt, 1, conceptIri);
            DALHelper.setString(stmt, 2, name);
            DALHelper.setString(stmt, 3, description);
            if (hasValue(scheme)) {
                DALHelper.setString(stmt, 4, code);
                DALHelper.setString(stmt, 5, scheme);
            }

            if (stmt.executeUpdate() != 1)
                throw new IllegalStateException("Failed to create concept");

            return DALHelper.getGeneratedKey(stmt);
        }
    }
/*
    @Override
    public Integer getOrganisationDbid(Identifier organisation) throws SQLException {
        return getIdentifierDbid("map_organisation", organisation);
    }
    @Override
    public Integer getOrganisationDbidByAlias(String alias) throws SQLException {
        return getIdentifierDbidByAlias("map_organisation", alias);
    }
    @Override
    public int createOrganisation(Identifier organisation) throws SQLException {
        return createIdentifier("map_organisation", organisation);
    }

    @Override
    public Integer getSystemDbid(Identifier system) throws SQLException {
        return getIdentifierDbid("map_system", system);
    }
    @Override
    public Integer getSystemDbidByAlias(String alias) throws SQLException {
        return getIdentifierDbidByAlias("map_system", alias);
    }
    @Override
    public int createSystem(Identifier system) throws SQLException {
        return createIdentifier("map_system", system);
    }

    private Integer getIdentifierDbid(String table, Identifier identifier) throws SQLException {
        String sql = "SELECT id FROM " + table + "\n";

        if (identifier.getCodeScheme() != null && identifier.getValue() != null)
            sql += "WHERE code = ? AND scheme = ?\n";
        else
            sql += "WHERE display = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (identifier.getCodeScheme() != null && identifier.getValue() != null) {
                DALHelper.setString(stmt, 1, identifier.getValue());
                DALHelper.setString(stmt, 2, identifier.getCodeScheme());
            } else
                DALHelper.setString(stmt, 1, identifier.getDisplay());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }

        }
    }
    private Integer getIdentifierDbidByAlias(String table, String alias) throws SQLException {
        String sql = "SELECT id FROM " + table + " WHERE alias = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, alias);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }

        }
    }
    private int createIdentifier(String table, Identifier identifier) throws SQLException {
        String alias = identifier.getValue();
        if (alias == null || alias.isEmpty())
            alias = identifier.getDisplay();

        alias = MappingLogic.getShortString(alias);

        String sql = "INSERT INTO " + table + " (code, scheme, display, alias) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            DALHelper.setString(stmt, 1, identifier.getValue());
            DALHelper.setString(stmt, 2, identifier.getCodeScheme());
            DALHelper.setString(stmt, 3, identifier.getDisplay());
            DALHelper.setString(stmt, 4, alias);
            stmt.executeUpdate();
            return DALHelper.getGeneratedKey(stmt);
        }
    }

    @Override
    public Integer getSchemaDbid(String schema) throws SQLException {
        String sql = "SELECT id FROM map_schema WHERE name = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, schema);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }
        }
    }
    @Override
    public int createSchema(String schema) throws SQLException {
        String alias = MappingLogic.getShortString(schema);

        String sql = "INSERT INTO map_schema (name) VALUES (?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, schema);
            stmt.setString(2, alias);
            stmt.executeUpdate();
            return DALHelper.getGeneratedKey(stmt);
        }
    }

    @Override
    public Integer getContextDbid(int organisationDbid, int systemDbid, int schemaDbid) throws SQLException {
        String sql = "SELECT c.id,\n" +
            "@ow := IF(organisation IS null, 0, 1),\n" +
            "@sw := IF(`system` IS null, 0, 2),\n" +
            "@mw := IF(`schema` IS null, 0, 4),\n" +
            "@ow + @sw + @mw AS w\n" +
            "FROM map_context c\n" +
            "WHERE (l.organisation = o.id OR l.organisation IS NULL)\n" +
            "AND (l.system = s.id OR l.system IS NULL)\n" +
            "AND (l.schema = m.id OR l.schema IS NULL)\n" +
            "ORDER BY w DESC\n" +
            "LIMIT 1\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setInt(stmt, 1, organisationDbid);
            DALHelper.setInt(stmt, 2, systemDbid);
            DALHelper.setInt(stmt, 3, schemaDbid);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }
        }
    }
    @Override
    public int createContext(int organisationDbid, int systemDbid, int schemaDbid) throws SQLException {
        String sql = "INSERT INTO map_context (organisation, `system`, `schema`) VALUES (?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            DALHelper.setInt(stmt, 1, organisationDbid);
            DALHelper.setInt(stmt, 2, systemDbid);
            DALHelper.setInt(stmt, 3, schemaDbid);
            stmt.executeUpdate();
            return DALHelper.getGeneratedKey(stmt);
        }
    }

    public String getTableShort(Table table) throws SQLException {
        String sql = "SELECT short FROM map_table\n";

        if (table.getShort() != null)
            sql += "WHERE short = ?\n";
        else
            sql += "WHERE name = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (table.getShort() != null)
                DALHelper.setString(stmt, 1, table.getShort());
            else
                DALHelper.setString(stmt, 1, table.getName());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getString("short");
                else
                    return null;
            }

        }
    }
    public String createTableShort(Table table) throws SQLException {
        String result = table.getShort();
        if (result == null)
            MappingLogic.getShortString(table.getName());
        String sql = "INSERT INTO map_table (name, short) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, table.getName());
            DALHelper.setString(stmt, 2, result);
            stmt.executeUpdate();
            return result;
        }
    }



    public ConceptIdentifiers getPropertyConceptIdentifiers(String contextId, String field) throws SQLException {
        String sql = "SELECT c.id, c.iri, c.code, s.iri as scheme\n" +
            "FROM map_context x\n" +
            "JOIN map_context_property p ON p.context = x.id\n" +
            "JOIN concept c ON c.id = p.concept\n" +
            "LEFT JOIN concept s ON s.id = c.scheme\n" +
            "WHERE x.context = ?\n" +
            "AND p.property = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, contextId);
            DALHelper.setString(stmt, 2, field);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new ConceptIdentifiers()
                        .setDbid(rs.getInt("id"))
                        .setIri(rs.getString("iri"))
                        .setCode(rs.getString("code"))
                        .setScheme(rs.getString("scheme"));
                else
                    return null;
            }
        }
    }
    public ConceptIdentifiers createPropertyConcept(String contextId, String field) throws Exception {
        Integer contextDbid = getContextDbid(contextId);
        if (contextDbid == null)
            throw new IllegalStateException("Unknown context [" + contextId + "]");

        try {
            conn.setAutoCommit(false);
            String fieldInContext = contextId + "/" + field;

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(fieldInContext.getBytes(StandardCharsets.UTF_8));
            String hash = Base64.getEncoder().encodeToString(digest).substring(0, 40);
            Integer conceptDbid = null;
            String conceptIri = ":LP_" + hash;

            String sql = "INSERT INTO concept (iri, name, description, status, definition, namespace) VALUES (?, ?, ?, ?, '{}', 1)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                DALHelper.setString(stmt, 1, conceptIri);
                DALHelper.setString(stmt, 2, "Legacy property " + hash);
                DALHelper.setString(stmt, 3, "Legacy property " + field + " in context " + contextId);
                DALHelper.setByte(stmt, 4, Status.DRAFT.getValue());

                stmt.executeUpdate();

                conceptDbid = DALHelper.getGeneratedKey(stmt);
            }

            sql = "INSERT INTO map_context_property (context, property, concept) VALUES (?, ?, ?)\n";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                DALHelper.setInt(stmt, 1, contextDbid);
                DALHelper.setString(stmt, 2, field);
                DALHelper.setInt(stmt, 3, conceptDbid);
                stmt.executeUpdate();
            }

            conn.commit();
            return new ConceptIdentifiers()
                .setDbid(conceptDbid)
                .setIri(conceptIri)
                .setCode(hash)
                .setScheme(GENERATED_SCHEME);
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    public ConceptIdentifiers getValueConceptIdentifiers(String contextId, Field field) throws SQLException {
        String sql = "SELECT c.id, c.iri, c.code, s.iri AS scheme\n" +
            "FROM concept c\n" +
            "JOIN map_context x ON x.context = ?\n" +
            "JOIN map_context_property p ON p.context = x.id AND p.property = ?\n" +
            "JOIN map_context_property_value v ON v.context_property = p.id AND v.concept = c.id\n" +
            "LEFT JOIN concept s ON s.id = c.scheme\n";

        if (field.getValue() != null && !field.getValue().isEmpty())
            sql += "WHERE v.value = ?\n";
        else
            sql += "WHERE v.term = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, contextId);
            DALHelper.setString(stmt, 2, field.getName());
            if (field.getValue() != null && !field.getValue().isEmpty())
                DALHelper.setString(stmt, 3, field.getValue());
            else
                DALHelper.setString(stmt, 3, field.getTerm());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new ConceptIdentifiers()
                        .setDbid(rs.getInt("id"))
                        .setIri(rs.getString("iri"))
                        .setCode(rs.getString("code"))
                        .setScheme(rs.getString("scheme"));
                else
                    return null;
            }
        }
    }
    public ConceptIdentifiers createValueConcept(String contextId, Field field) throws Exception {
        Integer contextDbid = getContextDbid(contextId);
        if (contextDbid == null)
            throw new IllegalStateException("Unknown context [" + contextId + "]");

        ConceptIdentifiers propertyConcept = getPropertyConceptIdentifiers(contextId, field.getName());
        if (propertyConcept == null)
            createPropertyConcept(contextId, field.getName());

        try {
            conn.setAutoCommit(false);

            String fieldValue = field.getName();
            if (field.getValue() != null && !field.getValue().isEmpty())
                fieldValue += "&value=" + field.getValue();
            else
                fieldValue += "&term=" + field.getTerm();

            String fieldValueInContext = contextId + "/" + fieldValue;

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(fieldValueInContext.getBytes(StandardCharsets.UTF_8));
            String hash = Base64.getEncoder().encodeToString(digest).substring(0, 40);
            Integer conceptDbid = null;
            String conceptIri = ":LPV_" + hash;

            String sql = "INSERT INTO concept (iri, name, description, status, definition, namespace) VALUES (?, ?, ?, ?, '{}', 1)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                DALHelper.setString(stmt, 1, conceptIri);
                DALHelper.setString(stmt, 2, "Legacy property " + hash);
                DALHelper.setString(stmt, 3, "Legacy property " + fieldValue + " in context " + contextId);
                DALHelper.setByte(stmt, 4, Status.DRAFT.getValue());

                stmt.executeUpdate();

                conceptDbid = DALHelper.getGeneratedKey(stmt);
            }

            sql = "INSERT INTO map_context_property_value (context_property, value, term, concept)\n" +
                "SELECT p.id, ?, ?, ?\n" +
                "FROM map_context_property p\n" +
                "WHERE p.context = ? AND p.property = ?\n";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                DALHelper.setString(stmt, 1, field.getValue());
                DALHelper.setString(stmt, 2, field.getTerm());
                DALHelper.setInt(stmt, 3, conceptDbid);
                DALHelper.setInt(stmt, 4, contextDbid);
                DALHelper.setString(stmt, 5, field.getName());

                stmt.executeUpdate();
            }

            conn.commit();
            return new ConceptIdentifiers()
                .setDbid(conceptDbid)
                .setIri(conceptIri)
                .setCode(hash)
                .setScheme(GENERATED_SCHEME);
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(false);
        }
    }



    public Integer getContextDbid(String contextId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM map_context WHERE context = ?")) {
            DALHelper.setString(stmt, 1, contextId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }
        }
    }
*/

    public void close() {
        ConnectionPool.getInstance().push(this.conn);
    }

}
