package org.endeavourhealth.im.cache;

import org.endeavourhealth.common.cache.CacheManager;
import org.endeavourhealth.common.cache.ICache;
import org.endeavourhealth.im.dal.ConnectionPool;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class SchemeCodePrefixCache implements ICache {
    private static HashMap<String, String> map = new HashMap<>();

    public SchemeCodePrefixCache() {
        CacheManager.registerCache(this);
    }

    @Override
    public String getName() {
        return "Scheme Code Prefix cache";
    }

    @Override
    public long getSize() {
        return map.size();
    }

    @Override
    public void clearCache() {
        map.clear();
    }

    public String get(String scheme) throws SQLException {
        String prefix = map.get(scheme);

        if (prefix == null) {
            String sql = "SELECT d.value\n" +
                "FROM concept_property_data d\n" +
                "JOIN concept c ON c.dbid = d.dbid\n" +
                "JOIN concept p ON p.dbid = d.property\n" +
                "WHERE c.id = ?\n" +
                "AND p.id = 'code_prefix'";

            try (Connection conn = ConnectionPool.getInstance().pop();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, scheme);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        prefix = rs.getString(1);
                        map.put(scheme, prefix);
                    }
                }
            }
        }

        return prefix;

    }
}
