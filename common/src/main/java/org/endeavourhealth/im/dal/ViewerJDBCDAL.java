package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.RelatedConcept;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class ViewerJDBCDAL {
    public List<RelatedConcept> getTargets(String id, List<String> relationships) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();
        List<RelatedConcept> result = new ArrayList<>();


        String sql = "SELECT p.id AS r_id, p.name AS r_name, v.id AS c_id, v.name AS c_name\n" +
            "FROM concept_property_object o\n" +
            "JOIN concept c ON c.dbid = o.dbid AND c.id = ?\n" +
            "JOIN concept p ON p.dbid = o.property\n" +
            "JOIN concept v ON v.dbid = o.value\n";

        if (relationships != null && relationships.size() > 0)
            sql += "WHERE p.id IN (" + DALHelper.inListParams(relationships.size()) + ")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;
            stmt.setString(i++, id);

            if (relationships != null)
                for(String relationship: relationships)
                    stmt.setString(i++, relationship);

             try(ResultSet rs = stmt.executeQuery()) {
                 while (rs.next()) {
                     result.add(new RelatedConcept()
                         .setRelationship(new Concept()
                             .setId(rs.getString("r_id"))
                             .setName(rs.getString("r_name"))
                         )
                         .setConcept(
                             new Concept()
                                 .setId(rs.getString("c_id"))
                                 .setName(rs.getString("c_name"))
                         )
                     );
                 }
             }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    public List<RelatedConcept> getSources(String id, List<String> relationships) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();
        List<RelatedConcept> result = new ArrayList<>();


        String sql = "SELECT p.id AS r_id, p.name AS r_name, c.id AS c_id, c.name AS c_name\n" +
            "FROM concept_property_object o\n" +
            "JOIN concept v ON v.dbid = o.value AND v.id = ?\n" +
            "JOIN concept p ON p.dbid = o.property\n" +
            "JOIN concept c ON c.dbid = o.dbid\n";

        if (relationships != null && relationships.size() > 0)
            sql += "WHERE p.id IN (" + DALHelper.inListParams(relationships.size()) + ")";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            int i = 1;
            stmt.setString(i++, id);

            if (relationships != null)
                for(String relationship: relationships)
                    stmt.setString(i++, relationship);

            try(ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    result.add(new RelatedConcept()
                        .setRelationship(new Concept()
                            .setId(rs.getString("r_id"))
                            .setName(rs.getString("r_name"))
                        )
                        .setConcept(
                            new Concept()
                                .setId(rs.getString("c_id"))
                                .setName(rs.getString("c_name"))
                        )
                    );
                }
            }
        } finally {
            ConnectionPool.getInstance().push(conn);
        }

        return result;
    }

    public Concept getConcept(String id) throws SQLException {
        Connection conn = ConnectionPool.getInstance().pop();

        String sql = "SELECT name, description FROM concept WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next())
                    return null;
                else
                    return new Concept()
                    .setId(id)
                    .setName(rs.getString("name"))
                    .setDescription(rs.getString("description"));
            }

        } finally {
            ConnectionPool.getInstance().push(conn);
        }
    }
}
