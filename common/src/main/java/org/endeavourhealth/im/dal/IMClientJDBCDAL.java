package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.cache.SchemeCodePrefixCache;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.Base64;

public class IMClientJDBCDAL {
    private static SchemeCodePrefixCache schemeCodePrefixMap = new SchemeCodePrefixCache();
    // By Concept Dbid
    public Integer getConceptDbidForSchemeCode(String context, String scheme, String code, Boolean autoCreate, String term) throws SQLException {
        Integer dbid = null;

        if (autoCreate && term == null)
            throw new IllegalArgumentException("Term must be supplied if AutoCreate is TRUE");

        String prefix = schemeCodePrefixMap.get(scheme);

        if (prefix == null && autoCreate)
            throw new IllegalArgumentException("No prefix set for code scheme [" + scheme + "]");

        try (Connection conn = ConnectionPool.getInstance().pop()) {

            conn.setAutoCommit(false);
            try {
                // Check for existing
                try (PreparedStatement statement = conn.prepareStatement("SELECT c.dbid FROM concept c JOIN concept s ON s.dbid = c.scheme AND s.id = ? WHERE c.code = ?")) {
                // try (PreparedStatement statement = conn.prepareStatement("SELECT c.dbid FROM concept c WHERE id = ?")) {
                //    statement.setString(1, prefix + code);
                    statement.setString(1, scheme);
                    statement.setString(2, code);

                    try (ResultSet resultSet = statement.executeQuery()) {
                        if (resultSet.next()) {
                            dbid = resultSet.getInt(1);
                            tickConcept(conn, dbid);
                        }
                    }
                }

                if (dbid == null && autoCreate) {
                    // None found, so create a new draft
                    dbid = createDraftCodeableConcept(conn, scheme, code, term);
                }

                conn.commit();
                return dbid;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private int createDraftCodeableConcept(Connection conn, String scheme, String code, String term) throws SQLException {
        int schemeDbid;
        int docDbid;
        String prefix;
        int conceptDbid;

        String sql = "SELECT c.dbid, c.document, d.value\n" +
            "FROM concept c\n" +
            "JOIN concept_property_data d ON d.dbid = c.dbid\n" +
            "JOIN concept v ON v.dbid = d.property\n" +
            "WHERE c.id = ?\n" +
            "AND v.id = 'code_prefix'";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, scheme);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next())
                    throw new IllegalArgumentException("Unknown code scheme [" + scheme + "]");

                schemeDbid = rs.getInt("dbid");
                docDbid = rs.getInt("document");
                prefix = rs.getString("value");
            }
        }

        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id, name, description, code, scheme, draft) VALUES (?, ?, ?, ?, ?, ?, TRUE)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, docDbid);
            stmt.setString(2, prefix + code);
            DALHelper.setString(stmt, 3, term);
            DALHelper.setString(stmt, 4, term);
            DALHelper.setString(stmt, 5, code);
            DALHelper.setInt(stmt, 6, schemeDbid);

            stmt.execute();
            conceptDbid = DALHelper.getGeneratedKey(stmt);
        }

        try (PreparedStatement stmt = conn.prepareStatement("UPDATE document SET draft = TRUE WHERE dbid = ?")) {
            stmt.setInt(1, docDbid);
            stmt.execute();
        }
        return conceptDbid;
    }

    public Integer getMappedCoreConceptDbidForSchemeCode(String scheme, String code) throws SQLException {
        // SNOMED codes ARE core so dont have/need maps
        if ("SNOMED".equals(scheme))
            return this.getConceptDbidForSchemeCode(null, scheme, code, false, null);

        String sql = "SELECT map.value\n" +
            "FROM concept c\n" +
            "JOIN concept s ON s.dbid = c.scheme\n" +
            "JOIN concept_property_object map ON map.dbid = c.dbid\n" +
            "JOIN concept equiv ON equiv.dbid = map.property AND equiv.id = 'is_equivalent_to'\n" +
            "WHERE s.id = ?\n" +
            "AND c.code = ?";

        ;
        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, scheme);
            statement.setString(2, code);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    int dbid = resultSet.getInt(1);
                    tickConcept(conn, dbid);
                    return dbid;
                }
                else
                    return null;
            }
        }
    }

    public String getCodeForConceptDbid(Integer dbid) throws SQLException {
        String sql = "SELECT c.code\n" +
            "FROM concept c\n" +
            "WHERE c.dbid = ?";

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, dbid);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    tickConcept(conn, dbid);
                    return resultSet.getString(1);
                }
                else
                    return null;
            }
        }
    }

    public Integer getConceptDbidForTypeTerm(String type, String term, Boolean autoCreate) throws SQLException, NoSuchAlgorithmException {
        Integer dbid = null;
        String sql = "SELECT m.target \n" +
            "FROM concept c\n" +
            "JOIN concept_term_map m ON m.type = c.dbid\n" +
            "WHERE c.id = ? \n" +
            "AND m.term = ?";

        try (Connection conn = ConnectionPool.getInstance().pop()) {
            conn.setAutoCommit(false);
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, type);
                statement.setString(2, term);

                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        dbid = resultSet.getInt("target");
                        tickConcept(conn, dbid);
                    } else if (autoCreate)
                        dbid = createTypeTermConcept(conn, type, term);
                }

                conn.commit();
                return dbid;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }
    private int createTypeTermConcept(Connection conn, String type, String term) throws SQLException, NoSuchAlgorithmException {
        int typDbid;
        int docDbid;
        int scmDbid;
        String scmId;

        // Get term type ids
        try (PreparedStatement stmt = conn.prepareStatement("SELECT c.dbid, c.document, c.scheme, s.id FROM concept c JOIN concept s ON s.dbid = c.scheme WHERE c.id = ?")) {
            stmt.setString(1, type);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next())
                    throw new IllegalArgumentException("Unknown term type [" + type + "]");
                typDbid = rs.getInt("dbid");
                docDbid = rs.getInt("document");
                scmDbid = rs.getInt("scheme");
                scmId = rs.getString("id");
            }
        }

        int mapDbid;
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest((type + term).getBytes(StandardCharsets.UTF_8));
        String code = Base64.getEncoder().encodeToString(digest).substring(0, 17);
        String id = schemeCodePrefixMap.get(scmId) + code;

        // Create the draft concept
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO concept (document, id, name, description, draft, scheme, code) VALUES (?, ?, ?, ?, TRUE, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, docDbid);
            stmt.setString(2, id);
            DALHelper.setString(stmt, 3, term);
            DALHelper.setString(stmt, 4, term);
            stmt.setInt(5, scmDbid);
            DALHelper.setString(stmt, 6, code);
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

    public Integer getMappedCoreConceptDbidForTypeTerm(String type, String term) throws SQLException {
        String sql = "SELECT p.value\n" +
            "FROM concept t\n" +
            "JOIN concept_term_map m ON m.type = t.dbid and m.term = ?\n" +
            "JOIN concept_property_object p ON p.dbid = m.target\n" +
            "JOIN concept e ON e.dbid = p.property AND e.id = 'is_equivalent_to'\n" +
            "WHERE t.id = ?";

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setString(1, term);
            statement.setString(2, type);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    int dbid = resultSet.getInt("value");
                    tickConcept(conn, dbid);
                    return dbid;
                } else
                    return null;
            }
        }
    }


    // By Code
    public String getConceptIdForSchemeCode(String scheme, String code) throws SQLException {
        String sql = "SELECT c.id\n" +
            "FROM concept c\n" +
            "JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE c.code = ?\n" +
            "AND s.id = ?\n";

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            stmt.setString(2, scheme);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String id = rs.getString("id");
                    tickConcept(conn, id);
                    return id;
                } else
                    return null;
            }
        }
    }

    public String getMappedCoreCodeForSchemeCode(String scheme, String code, boolean snomedOnly) throws SQLException {
        String sql = "SELECT c.dbid, c.code\n" +
            "FROM concept l\n" +
            "JOIN concept s ON s.dbid = l.scheme\n" +
            "JOIN concept_property_object o ON o.dbid = l.dbid\n" +
            "JOIN concept p ON p.dbid = o.property AND p.id = 'is_equivalent_to'\n" +
            "JOIN concept c ON c.dbid = o.value\n";

        if (snomedOnly)
            sql += "JOIN concept so ON so.dbid = c.scheme AND so.id = 'SNOMED'\n";

        sql += "WHERE l.code = ?\n" +
            "AND s.id = ?";

        try (Connection conn = ConnectionPool.getInstance().pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            stmt.setString(2, scheme);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    tickConcept(conn, rs.getInt("dbid"));
                    return rs.getString("code");
                } else
                    return null;
            }
        }
    }

    public String getCodeForTypeTerm(String scheme, String context, String term, boolean autoCreate) throws SQLException, NoSuchAlgorithmException {
        String sql = "SELECT t.dbid, t.code\n" +
            "FROM concept c\n" +
            "JOIN concept s ON s.dbid = c.scheme AND s.id = ?\n" +
            "JOIN concept_term_map m on m.type = c.dbid\n" +
            "JOIN concept t ON t.dbid = m.target\n" +
            "WHERE c.code = ?\n" +
            "AND m.term = ?";

        try (Connection conn = ConnectionPool.getInstance().pop()) {
            conn.setAutoCommit(false);

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                String result = null;
                stmt.setString(1, scheme);
                stmt.setString(2, context);
                stmt.setString(3, term);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        tickConcept(conn, rs.getInt("dbid"));
                        result = rs.getString("code");
                    } else {
                        if (autoCreate)
                            result = createTermTypeConceptAndMap(conn, scheme, context, term);
                    }
                }
                conn.commit();
                return result;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private String createTermTypeConceptAndMap(Connection conn, String scheme, String context, String term) throws SQLException, NoSuchAlgorithmException {
        // Generate 17 character encoding of 100-bit hash
        // SQL version: SELECT LEFT(TO_BASE64(UNHEX(SHA2("SARS-CoV-2 RNA DETECTED", 256))), 17);

        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest(term.getBytes(StandardCharsets.UTF_8));
        String code = Base64.getEncoder().encodeToString(digest).substring(0, 17);

        String id = schemeCodePrefixMap.get(scheme) + code;

        String sql = "INSERT INTO concept\n" +
            "(document, id, draft, name, description, scheme, code)\n" +
            "SELECT s.document, ?, 1, ?, ?, s.dbid, ?\n" +
            "FROM concept s\n" +
            "WHERE s.id = ?";

        int dbid;
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, id);
            stmt.setString(2, term);
            stmt.setString(3, term);
            stmt.setString(4, code);
            stmt.setString(5, scheme);

            if (stmt.executeUpdate() == 0)
                throw new IllegalStateException("Unable to create draft term type concept!");

            dbid = DALHelper.getGeneratedKey(stmt);
        }

        sql = "INSERT INTO concept_term_map\n" +
            "(term, type, target, draft)\n" +
            "SELECT ?, t.dbid, ?, 1\n" +
            "FROM concept t\n" +
            "JOIN concept s ON s.dbid = t.scheme AND s.id = ?\n" +
            "WHERE t.code = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, term);
            stmt.setInt(2, dbid);
            stmt.setString(3, scheme);
            stmt.setString(4, context);

            if (stmt.executeUpdate() == 0)
                throw new IllegalStateException("Unable to create draft term type map!");
        }

        return code;
    }


    // Usage
    public void tickConcept(Connection conn, String id) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("UPDATE concept SET use_count = use_count + 1 WHERE id = ?")) {
            stmt.setString(1, id);
            stmt.executeUpdate();
        }
    }

    public void tickConcept(Connection conn, int dbid) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("UPDATE concept SET use_count = use_count + 1 WHERE dbid = ?")) {
            stmt.setInt(1, dbid);
            stmt.executeUpdate();
        }
    }
}
