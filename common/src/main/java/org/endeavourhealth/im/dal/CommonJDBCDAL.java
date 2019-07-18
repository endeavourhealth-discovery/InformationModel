package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommonJDBCDAL {
    public List<KVP> getCodeSchemes() throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();
        List<KVP> result = new ArrayList<>();

        String sql = "SELECT c.dbid, c.name\n" +
            "FROM concept c\n" +
            "JOIN concept st ON st.id = 'is_subtype_of'\n" +
            "JOIN concept cs ON cs.id = 'CodeScheme'\n" +
            "JOIN concept_property_object o ON c.dbid = o.dbid  AND o.property = st.dbid AND o.value = cs.dbid\n";

        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                result.add(new KVP()
                    .setKey(rs.getInt("dbid"))
                    .setValue(rs.getString("name"))
                );
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    public SearchResult search(String term, List<Integer> schemes, Integer page, Integer pageSize) throws SQLException {
        SearchResult result = new SearchResult();

        if (page == null) page = 1;
        if (pageSize == null) pageSize = 15;
        int offset = (page-1) * pageSize;

        String sql = "SELECT SQL_CALC_FOUND_ROWS c.dbid, c.id, c.name, s.id as scheme, c.code\n" +
            "FROM concept c\n" +
            "JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE (c.name LIKE ? OR c.code LIKE ?)\n";

        if (schemes != null && schemes.size() > 0)
            sql += "AND c.scheme IN (" + DALHelper.inListParams(schemes.size()) + ")";

        sql += "ORDER BY LENGTH(c.name)\n" +
            "LIMIT ?,?";

        Connection conn = ConnectionPool.getInstance().pop();
        try {
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                int i = 1;
                stmt.setString(i++, term + '%');
                stmt.setString(i++, term + '%');

                if (schemes != null) {
                    for (int s : schemes)
                        stmt.setInt(i++, s);
                }

                stmt.setInt(i++, offset);
                stmt.setInt(i++, pageSize);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        CodeableConcept concept = new CodeableConcept();
                        concept
                            .setScheme(rs.getString("scheme"))
                            .setCode(rs.getString("code"))
                            .setDbid(rs.getInt("dbid"))
                            .setId(rs.getString("id"))
                            .setName(rs.getString("name"));
                        result.getResults().add(concept);
                    }
                }
            }
            try (PreparedStatement statement = conn.prepareStatement("SELECT FOUND_ROWS()");
                 ResultSet rs = statement.executeQuery()) {
                rs.next();
                result.setCount(rs.getInt(1));
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    public List<Related> getRelated(String id, List<String> relationships) throws SQLException {
        List<Related> result = new ArrayList<>();

        String sql = "SELECT op.id AS rel_id, op.name AS rel_name, ov.id, ov.name, s.id as scheme, ov.code\n" +
            "FROM concept c\n" +
            "JOIN concept_property_object o ON o.dbid = c.dbid\n" +
            "JOIN concept op ON op.dbid = o.property\n" +
            "JOIN concept ov ON ov.dbid = o.value\n" +
            "JOIN concept s ON s.dbid = ov.scheme\n" +
            "WHERE c.id = ?";

        String lastRelId = "";
        Related rel = null;

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    String relId = rs.getString("rel_id");

                    if (relationships != null && !relationships.contains(relId))
                        continue;

                    if (!relId.equals(lastRelId)) {
                        lastRelId = relId;

                        result.add(
                            rel = new Related()
                                .setId(relId)
                                .setName(rs.getString("rel_name"))
                        );
                    }

                    CodeableConcept cc = new CodeableConcept();
                    cc.setScheme(rs.getString("scheme"))
                        .setCode(rs.getString("code"))
                        .setId(rs.getString("id"))
                        .setName(rs.getString("name"));

                    rel.getConcepts().add(cc);
                }
            }

        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    public List<Related> getReverseRelated(String id, List<String> relationships) throws SQLException {
        List<Related> result = new ArrayList<>();

        String sql = "SELECT op.id AS rel_id, op.name AS rel_name, c.id, c.name, s.id as scheme, c.code\n" +
            "FROM concept c\n" +
            "JOIN concept_property_object o ON o.dbid = c.dbid\n" +
            "JOIN concept op ON op.dbid = o.property\n" +
            "JOIN concept ov ON ov.dbid = o.value\n" +
            "JOIN concept s ON s.dbid = c.scheme\n" +
            "WHERE ov.id = ?";

        String lastRelId = "";
        Related rel = null;

        Connection conn = ConnectionPool.getInstance().pop();
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    String relId = rs.getString("rel_id");

                    if (relationships != null && !relationships.contains(relId))
                        continue;

                    if (!relId.equals(lastRelId)) {
                        lastRelId = relId;

                        result.add(
                            rel = new Related()
                                .setId(relId)
                                .setName(rs.getString("rel_name"))
                        );
                    }

                    CodeableConcept cc = new CodeableConcept();
                    cc.setScheme(rs.getString("scheme"))
                        .setCode(rs.getString("code"))
                        .setId(rs.getString("id"))
                        .setName(rs.getString("name"));

                    rel.getConcepts().add(cc);
                }
            }

        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }
}
