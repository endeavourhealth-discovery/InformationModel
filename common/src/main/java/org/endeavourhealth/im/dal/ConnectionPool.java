package org.endeavourhealth.im.dal;

import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.cache.GenericCache;
import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.utility.MetricsHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConnectionPool extends GenericCache<Connection> {
    private static final Logger LOG = LoggerFactory.getLogger(ConnectionPool.class);
    private static final int VALID_TIMEOUT = 5;
    private static ConnectionPool instance = null;

    public static ConnectionPool getInstance() {
        if (instance == null)
            instance = new ConnectionPool();

        return instance;
    }

    @Override
    protected boolean isValid(Connection connection) {
        try {
            if (connection == null)
                return false;

            if (connection.isValid(VALID_TIMEOUT)) {
                connection.setAutoCommit(true);
                return true;
            }

            MetricsHelper.recordCounter("ConnectionPool.Size").dec();

            if (!connection.isClosed())
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
            JsonNode json = ConfigManager.getConfigurationAsJson("database");
            String url = json.get("url").asText();
            String user = json.get("username").asText();
            String pass = json.get("password").asText();
            String driver = json.get("class") == null ? null : json.get("class").asText();

            if (driver != null && !driver.isEmpty())
                Class.forName(driver);

            Properties props = new Properties();

            props.setProperty("user", user);
            props.setProperty("password", pass);

            Connection connection = DriverManager.getConnection(url, props);    // NOSONAR

            LOG.debug("New DB Connection created");

            MetricsHelper.recordCounter("ConnectionPool.Size").inc();
            return connection;
        } catch (Exception e) {
            LOG.error("Error getting connection", e);
        }
        return null;
    }

    @Override
    public Connection pop() {
        Connection conn = super.pop();
        MetricsHelper.recordCounter("ConnectionPool.InUse").inc();
        return conn;
    }

    @Override
    public void push(Connection conn) {
        super.push(conn);
        MetricsHelper.recordCounter("ConnectionPool.InUse").dec();
    }
}
