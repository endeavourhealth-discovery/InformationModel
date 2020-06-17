package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.logic.MappingLogic;
import org.endeavourhealth.im.models.Status;
import org.endeavourhealth.im.models.mapping.Field;
import org.endeavourhealth.im.models.mapping.Identifier;
import org.endeavourhealth.im.models.mapping.Table;

import javax.swing.plaf.nimbus.State;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

public class IMMappingJDBCDAL implements IMMappingDAL {
    private final Connection conn;

    public IMMappingJDBCDAL()  {
        this.conn = ConnectionPool.getInstance().pop();
    }

    public String getOrganisationId(Identifier organisation) throws SQLException {
        return getIdentifierId("map_organisation", organisation);
    }
    public String createOrganisationId(Identifier organisation) throws SQLException {
        return createIdentifierId("map_organisation", organisation);
    }

    public String getSystemId(Identifier system) throws SQLException {
        return getIdentifierId("map_system", system);
    }
    public String createSystemId(Identifier system) throws SQLException {
        return createIdentifierId("map_system", system);
    }

    public String getSchemaId(Identifier schema) throws SQLException {
        return getIdentifierId("map_schema", schema);
    }
    public String createSchemaId(Identifier schema) throws SQLException {
        return createIdentifierId("map_schema", schema);
    }

    private String getIdentifierId(String table, Identifier identifier) throws SQLException {
        String sql = "SELECT short FROM " + table + "\n";

        if (identifier.getShort() != null)
            sql += "WHERE short = ?\n";
        else if (identifier.getScheme() != null && identifier.getValue() != null)
            sql += "WHERE code = ? AND scheme = ?\n";
        else
            sql += "WHERE display = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (identifier.getShort() != null)
                DALHelper.setString(stmt, 1, identifier.getShort());
            else if (identifier.getScheme() != null && identifier.getValue() != null) {
                DALHelper.setString(stmt, 1, identifier.getValue());
                DALHelper.setString(stmt, 2, identifier.getScheme());
            } else
                DALHelper.setString(stmt, 1, identifier.getDisplay());

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getString("short");
                else
                    return null;
            }

        }
    }
    private String createIdentifierId(String table, Identifier identifier) throws SQLException {
        String result = identifier.getShort();
        if (result == null)
            result = MappingLogic.getShortIdentifier(identifier);

        String sql = "INSERT INTO " + table + " (code, scheme, display, short) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, identifier.getValue());
            DALHelper.setString(stmt, 2, identifier.getScheme());
            DALHelper.setString(stmt, 3, identifier.getDisplay());
            DALHelper.setString(stmt, 4, result);
            stmt.executeUpdate();
            return result;
        }
    }

    public String getTableId(Table table) throws SQLException {
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
    public String createTableId(Table table) throws SQLException {
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

    public String getContextId(String orgId, String sysId, String scmId, String tblId) throws SQLException {
        String sql = "SELECT c.context,\n" +
            "@ow := IF(organisation IS null, 0, 1),\n" +
            "@sw := IF(`system` IS null, 0, 2),\n" +
            "@mw := IF(`schema` IS null, 0, 4),\n" +
            "@tw := IF(`table` IS null, 0, 8),\n" +
            "@ow + @sw + @mw + @tw AS w\n" +
            "FROM map_context c\n" +
            "JOIN map_context_lookup l ON l.context = c.id\n" +
            "JOIN map_organisation o ON o.short = ?\n" +
            "JOIN map_system s ON s.short = ?\n" +
            "JOIN map_schema m ON m.short = ?\n" +
            "JOIN map_table t ON t.short = ?\n" +
            "WHERE (l.organisation = o.id OR l.organisation IS NULL)\n" +
            "AND (l.system = s.id OR l.system IS NULL)\n" +
            "AND (l.schema = m.id OR l.schema IS NULL)\n" +
            "AND (l.table = t.id OR l.table IS NULL)" +
            "ORDER BY w DESC\n" +
            "LIMIT 1\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, orgId);
            DALHelper.setString(stmt, 2, sysId);
            DALHelper.setString(stmt, 3, scmId);
            DALHelper.setString(stmt, 4, tblId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getString("context");
                else
                    return null;
            }
        }
    }
    public String createContextId(String orgId, String sysId, String scmId, String tblId) throws SQLException {
        try {
            conn.setAutoCommit(false);
            String context = "/" + orgId + "/" + sysId + "/" + scmId + "/" + tblId;
            Integer contextId = null;

            String sql = "INSERT INTO map_context (context) VALUES (?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                DALHelper.setString(stmt, 1, context);
                stmt.executeUpdate();
                contextId = DALHelper.getGeneratedKey(stmt);
            }

            sql = "INSERT INTO map_context_lookup (organisation, `system`, `schema`, `table`, context)\n" +
                "SELECT o.id, s.id, m.id, t.id, ?\n" +
                "FROM map_organisation o\n" +
                "JOIN map_system s ON s.short = ?\n" +
                "JOIN map_schema m ON m.short = ?\n" +
                "JOIN map_table t ON t.short = ?\n" +
                "WHERE o.short = ?\n";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                DALHelper.setInt(stmt, 1, contextId);
                DALHelper.setString(stmt, 2, sysId);
                DALHelper.setString(stmt, 3, scmId);
                DALHelper.setString(stmt, 4, tblId);
                DALHelper.setString(stmt, 5, orgId);

                stmt.executeUpdate();
            }
            conn.commit();
            return context;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    public String getPropertyConceptIri(String contextId, String field) throws SQLException {
        String sql = "SELECT c.id, c.iri\n" +
            "FROM map_context x\n" +
            "JOIN map_context_property p ON p.context = x.id\n" +
            "JOIN concept c ON c.id = p.concept\n" +
            "WHERE x.context = ?\n" +
            "AND p.property = ?\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, contextId);
            DALHelper.setString(stmt, 2, field);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getString("iri");
                else
                    return null;
            }
        }
    }
    public String createPropertyConceptIri(String contextId, String field) throws Exception {
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
            return conceptIri;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    public String getValueConceptIri(String contextId, Field field) throws SQLException {
        String sql = "SELECT c.iri\n" +
            "FROM concept c\n" +
            "JOIN map_context x ON x.context = ?\n" +
            "JOIN map_context_property p ON p.context = x.id AND p.property = ?\n" +
            "JOIN map_context_property_value v ON v.context_property = p.id AND v.concept = c.id\n";

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
                    return rs.getString("iri");
                else
                    return null;
            }
        }
    }
    public String createValueConceptIri(String contextId, Field field) throws Exception {
        Integer contextDbid = getContextDbid(contextId);
        if (contextDbid == null)
            throw new IllegalStateException("Unknown context [" + contextId + "]");

        String propertyConceptIri = getPropertyConceptIri(contextId, field.getName());
        if (propertyConceptIri == null)
            createPropertyConceptIri(contextId, field.getName());

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
            return conceptIri;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(false);
        }
    }

    public Integer getConceptId(String conceptIri) throws SQLException {
        String sql = "SELECT dbid FROM concept WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            DALHelper.setString(stmt, 1, conceptIri);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getInt("id");
                else
                    return null;
            }
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

    public void close() {
        ConnectionPool.getInstance().push(this.conn);
    }
}
