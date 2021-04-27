package org.endeavourhealth.im.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ValueSetJDBCDAL {
    public Boolean isSchemeCodeMemberOfValueSet(String scheme, String code, String valueSet) throws SQLException {
        String sql = "SELECT c.dbid\n" +
            "FROM concept c\n" +
            "JOIN concept s ON s.dbid = c.scheme AND s.id = ?\n" +
            "JOIN value_set_member m ON m.concept = c.dbid\n" +
            "JOIN value_set v ON v.dbid = m.value_set\n" +
            "WHERE c.code = ?\n" +
            "AND v.id = ?";

        try (Connection conn = ConnectionPool.getInstance().pop();
        PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, scheme);
            stmt.setString(2, code);
            stmt.setString(3, valueSet);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }
}
