package org.endeavourhealth.im.api.dal;

import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.cache.GenericCache;
import org.endeavourhealth.common.config.ConfigManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConnectionCache extends GenericCache<Connection> {
    private static final Logger LOG = LoggerFactory.getLogger(ConnectionCache.class);
    private static final int VALID_TIMEOUT = 5;
    private String configName;

    public ConnectionCache(String configName) {
        this.configName = configName;
    }

    @Override
    protected boolean isValid(Connection connection) {
        try {
            if (connection == null || connection.isClosed())
                return false;

            if (connection.isValid(VALID_TIMEOUT))
                return true;

            connection.close();
            return false;
        } catch (SQLException e) {
            LOG.error("Error validating/cleaning up connection", e);
            return false;
        }
    }

    @Override
    protected Connection create() {
        try {
            JsonNode json = ConfigManager.getConfigurationAsJson(configName);
            String url = json.get("url").asText();
            String user = json.get("username").asText();
            String pass = json.get("password").asText();
            String driver = json.get("class") == null ? null : json.get("class").asText();

            if (driver != null && !driver.isEmpty())
                Class.forName(driver);

            Properties props = new Properties();

            props.setProperty("user", user);
            props.setProperty("password", pass);

            Connection connection = DriverManager.getConnection(url, props);

            LOG.debug("New DB Connection created");

            return connection;
        } catch (Exception e) {
            LOG.error("Error getting connection", e);
        }
        return null;
    }
}
