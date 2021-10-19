package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.Map;

public class ConfigHelper {
    private static final Logger LOG = LoggerFactory.getLogger(ConfigHelper.class);

    private static final String CONFIG_JDBC_USERNAME = "CONFIG_JDBC_USERNAME";
    private static final String CONFIG_JDBC_PASSWORD = "CONFIG_JDBC_PASSWORD";
    private static final String CONFIG_JDBC_URL = "CONFIG_JDBC_URL";

    private final String thisAppId;
    private final Connection conn;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public ConfigHelper(String appId) throws SQLException {
        this.thisAppId = appId;
        this.conn = getConnection();
    }

    public String get(String configId) throws SQLException {
        return get(thisAppId, configId);
    }

    public String get(String appId, String configId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("SELECT config_data FROM config WHERE app_id=? AND config_id=?")) {
            stmt.setString(1, appId);
            stmt.setString(2, configId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return rs.getString("config_data");
                else
                    return null;
            }
        }
    }

    public <T> T get(String configId, Class<T> valueType) throws SQLException, JsonProcessingException {
        return get(thisAppId, configId, valueType);
    }

    public <T> T get(String appId, String configId, Class<T> valueType) throws JsonProcessingException, SQLException {
        String json = get(appId, configId);
        if (json == null)
            return null;
        else
            return objectMapper.readValue(json, valueType);
    }

    public int set(String configId, String data) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement("INSERT INTO config (app_id, config_id, config_data) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE config_data = ?")) {
            stmt.setString(1, thisAppId);
            stmt.setString(2, configId);
            stmt.setString(3, data);
            stmt.setString(4, data);
            return stmt.executeUpdate();
        }
    }

    public int set(String configId, Object object) throws SQLException, JsonProcessingException {
        String json = objectMapper.writeValueAsString(object);
        return set(configId, json);
    }

    private Connection getConnection() throws SQLException {
        Map<String, String> envMap = System.getenv();

        if (!envMap.containsKey(CONFIG_JDBC_USERNAME)
            || !envMap.containsKey(CONFIG_JDBC_PASSWORD)
            || !envMap.containsKey(CONFIG_JDBC_URL)) {
            LOG.error("Config database settings not found.  Environment variable(s) missing");
            LOG.error("\tCONFIG_JDBC_USERNAME, CONFIG_JDBC_PASSWORD, CONFIG_JDBC_URL");
            System.exit(-1);
        }

        LOG.debug("Connecting to config database...");
        return DriverManager.getConnection(
            envMap.get(CONFIG_JDBC_URL),
            envMap.get(CONFIG_JDBC_USERNAME),
            envMap.get(CONFIG_JDBC_PASSWORD));
    }

}
