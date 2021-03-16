package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.logic.MappingLogic;
import org.endeavourhealth.im.models.mapping.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public class IMMappingJDBCDAL implements IMMappingDAL {
    private final String GENERATED_SCHEME = "CM_DiscoveryCode";

    private static boolean hasValue(String s) {
        return (s != null && !s.isEmpty());
    }

    @Override
    public MapNode getNode(String provider, String system, String schema, String table, String column, String target) throws SQLException {
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


        String sql = "SELECT n.id, n.node, t.id as target\n" +
            "FROM map_context m\n" +
            "JOIN map_node n ON n.id = m.node\n" +
            String.join("\n", join) + "\n" +
                "LEFT JOIN concept t ON t.dbid = n.target\n"+
            "WHERE " + String.join("\nAND ", where);

        try (Connection conn = ConnectionPool.getInstance().pop();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 0;
            if (hasValue(provider)) stmt.setString(++i, provider);
            if (hasValue(system)) stmt.setString(++i, system);
            if (hasValue(schema)) stmt.setString(++i, schema);
            if (hasValue(table)) stmt.setString(++i, table);
            if (hasValue(column)) stmt.setString(++i, column);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return new MapNode(rs.getInt("id"), rs.getString("node"),rs.getString("target"));
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

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
    public MapValueNode getValueNode(String node, String scheme) throws SQLException {
        String sql = "SELECT v.id, v.function\n" +
            "FROM map_value_node v\n" +
            "JOIN map_node n ON n.id = v.node AND n.node = ?\n";

        if (scheme == null || scheme.isEmpty()) {
            sql += "WHERE v.code_scheme IS NULL\n";
        } else {
            sql += "JOIN concept s ON s.dbid = v.code_scheme AND s.id = ?\n";
        }

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        try (Connection conn = ConnectionPool.getInstance().pop()) {
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
            }
        }
    }

    @Override
    public ConceptIdentifiers getConceptIdentifiers(String iri) throws SQLException {
        String sql = "SELECT c.dbid, c.code, s.id AS scheme\n" +
            "FROM concept c\n" +
            "LEFT JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE c.id = ?";

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        iri = "LPV_" + ids.stream().map(MappingLogic::getShortString).collect(Collectors.joining("_")) + "_" + cptId;

        // Update with final IRI
        String sql = "UPDATE concept SET id = ?, code = ? WHERE dbid = ?";
        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, iri);
            stmt.setString(2, iri);
            stmt.setInt(3, cptId);
            if (stmt.executeUpdate() != 1)
                throw new IllegalStateException("Unable to update temporary legacy mapping property value [" + cptId + "] ==> [" + iri + "]");
        }

        return new ConceptIdentifiers()
            .setDbid(cptId)
            .setIri(iri)
            .setCode(iri)
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

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
}
