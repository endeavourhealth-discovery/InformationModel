package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.cache.SchemeCodePrefixCache;

import java.sql.*;
import java.util.HashMap;

public class IMClientJDBCDAL {
    private static SchemeCodePrefixCache schemeCodePrefixMap = new SchemeCodePrefixCache();
    private HashMap<String, Integer> idMap = new HashMap<>();

    public Integer getConceptIdForSchemeCode(String context, String scheme, String code, Boolean autoCreate, String term) throws SQLException {
        Integer conceptId = null;

        if (autoCreate && term == null)
            throw new IllegalArgumentException("Term must be supplied if AutoCreate is TRUE");

        String prefix = schemeCodePrefixMap.get(scheme);

        if (prefix == null)
            throw new IllegalArgumentException("No prefix set for code scheme [" + scheme + "]");

        Connection conn = ConnectionPool.getInstance().pop();

        conn.setAutoCommit(false);
        try {
            // Check for existing
            try (PreparedStatement statement = conn.prepareStatement("SELECT c.dbid FROM concept c WHERE id = ?")) {
                statement.setString(1, prefix + code);

                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next())
                    conceptId = resultSet.getInt(1);
            }

            if (conceptId != null) {
                // Found one so increment use count
                try (PreparedStatement cnt = conn.prepareStatement("UPDATE concept SET use_count = use_count + 1 WHERE dbid = ?")) {
                    cnt.setInt(1, conceptId);
                    cnt.execute();
                }
            } else if (autoCreate) {
                // None found, so create a new draft
                conceptId = createDraftCodeableConcept(conn, scheme, code, term);
            }

            conn.commit();
            return conceptId;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
    private int createDraftCodeableConcept(Connection conn, String scheme, String code, String term) throws SQLException {
        int schemeDbid;
        int docDbid;
        String prefix;
        int conceptId;

        String sql = "SELECT c.dbid, c.document, d.value\n" +
            "FROM concept c\n" +
            "JOIN concept_property_data d ON d.dbid = c.dbid\n" +
            "JOIN concept v ON v.dbid = d.property\n" +
            "WHERE c.id = ?\n" +
            "AND v.id = 'code_prefix'";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, scheme);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next())
                throw new IllegalArgumentException("Unknown code scheme [" + scheme + "]");

            schemeDbid = rs.getInt("dbid");
            docDbid = rs.getInt("document");
            prefix = rs.getString("value");
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id, name, description, code, scheme, draft) VALUES (?, ?, ?, ?, ?, ?, TRUE)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, docDbid);
            stmt.setString(2, prefix + code);
            DALHelper.setString(stmt, 3, term);
            DALHelper.setString(stmt, 4, term);
            DALHelper.setString(stmt, 5, code);
            DALHelper.setInt(stmt, 6, schemeDbid);

            stmt.execute();
            conceptId = DALHelper.getGeneratedKey(stmt);
        }

        try (PreparedStatement stmt = conn.prepareStatement("UPDATE document SET draft = TRUE WHERE dbid = ?")) {
            stmt.setInt(1, docDbid);
            stmt.execute();
        }
        return conceptId;
    }

    public Integer getMappedCoreConceptIdForSchemeCode(String scheme, String code) throws SQLException {
        // SNOMED codes ARE core so dont have/need maps
        if ("SNOMED".equals(scheme))
            return this.getConceptIdForSchemeCode(null, scheme, code, false, null);

        String sql = "SELECT map.value\n" +
            "FROM concept c\n" +
            "JOIN concept_property_object map ON map.dbid = c.dbid\n" +
            "JOIN concept equiv ON equiv.dbid = map.property AND equiv.id = 'is_equivalent_to'\n" +
            "WHERE c.scheme = ?\n" +
            "AND c.code = ?";

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, scheme);
            statement.setString(2, code);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                return resultSet.getInt(1);
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    public String getCodeForConceptId(Integer dbid) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();

        String sql = "SELECT c.code\n" +
            "FROM concept c\n" +
            "WHERE c.dbid = ?";

        try (PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, dbid);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                return resultSet.getString(1);
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    public Integer getConceptIdForTypeTerm(String type, String term, Boolean autoCreate) throws SQLException {
        Integer conceptId = null;

        Connection conn = ConnectionPool.getInstance().pop();
        conn.setAutoCommit(false);
        try (PreparedStatement statement = conn.prepareStatement("SELECT target FROM concept_term_map WHERE type = ? AND term = ?")) {
            Integer typeId = getConceptDbid(conn, type);
            if (typeId == null)
                return null;

            statement.setInt(1, typeId);
            statement.setString(2, term);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                conceptId = resultSet.getInt("target");
            else if (autoCreate)
                conceptId = createTypeTermConcept(conn, type, term);

            conn.commit();
            return conceptId;
        } catch (Exception e) {
            conn.rollback();
            throw e;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
    private int createTypeTermConcept(Connection conn, String type, String term) throws SQLException {
        int typDbid;
        int docDbid;
        int mapDbid;

        // Get term type ids
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid, document FROM concept WHERE id = ?")) {
            stmt.setString(1, type);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next())
                throw new IllegalArgumentException("Unknown term type [" + type + "]");
            typDbid = rs.getInt("dbid");
            docDbid = rs.getInt("document");
        }

        // Create the draft concept
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id, name, description, draft) SELECT ?, CONCAT(?, '_', MAX(dbid) + 1), ?, ?, TRUE FROM concept", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, docDbid);
            stmt.setString(2, type);
            DALHelper.setString(stmt, 3, term);
            DALHelper.setString(stmt, 4, term);
            stmt.execute();
            mapDbid = DALHelper.getGeneratedKey(stmt);
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept_term_map (term, type, target, draft) VALUES (?, ?, ?, TRUE)")) {
            stmt.setString(1, term);
            stmt.setInt(2, typDbid);
            stmt.setInt(3, mapDbid);
            stmt.execute();
        }

        try (PreparedStatement stmt = conn.prepareStatement("UPDATE document SET draft = TRUE WHERE dbid = 0")) {
            stmt.execute();
        }

        return mapDbid;
    }

    public Integer getMappedCoreConceptIdForTypeTerm(String type, String term) throws SQLException {

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement statement = conn.prepareStatement("SELECT target FROM concept_term_map WHERE type = ? AND term = ?")) {
            Integer typeId = getConceptDbid(conn, type);
            if (typeId == null)
                return null;
            statement.setInt(1, typeId);
            statement.setString(2, term);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next())
                return resultSet.getInt("target");
            else
                return null;
        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }

    // ********** TO DO - REMOVE **********
    private Integer getConceptDbid(Connection conn, String id) throws SQLException {
        Integer conceptDbid = idMap.get(id);

        if (conceptDbid != null)
            return conceptDbid;

        try (PreparedStatement statement = conn.prepareStatement("SELECT dbid FROM concept WHERE id = ?")) {
            statement.setString(1, id);
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                conceptDbid = rs.getInt("dbid");
                idMap.put(id, conceptDbid);
                return conceptDbid;
            } else {
                return null;
            }
        }

    }
}
