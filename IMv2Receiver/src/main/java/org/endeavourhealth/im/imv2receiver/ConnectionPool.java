package org.endeavourhealth.im.imv2receiver;

import com.fasterxml.jackson.databind.JsonNode;
import com.zaxxer.hikari.HikariDataSource;
import org.endeavourhealth.common.config.ConfigManager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;

public class ConnectionPool {
    private static final Logger LOG = LoggerFactory.getLogger(ConnectionPool.class);
    private static final Object lock = new Object();
    private static ConnectionPool instance = null;

    public static ConnectionPool getInstance() {
        synchronized (lock) {
            if (instance == null) {
                try {
                    instance = new ConnectionPool();
                } catch (Exception e) {
                    LOG.error(e.getMessage());
                    return null;
                }
            }

            return instance;
        }
    }

    private HikariDataSource dataSource = null;

    public ConnectionPool() throws Exception {
        this.dataSource = new HikariDataSource();
        JsonNode json = ConfigManager.getConfigurationAsJson("database");
        String url = json.get("url").asText();
        String user = json.get("username").asText();
        String pass = json.get("password").asText();
        String driver = json.get("class") == null ? null : json.get("class").asText();
        if (driver != null && !driver.isEmpty())
            Class.forName(driver);

        int max = 10;
        int min = 2;
        int timeout = 120000;

        JsonNode maxNode = json.get("max");
        if (maxNode != null && maxNode.isNumber())
            max = maxNode.asInt();

        JsonNode minNode = json.get("min");
        if (minNode != null && minNode.isNumber())
            min = minNode.asInt();

        JsonNode timeoutNode = json.get("timeoutms");
        if (timeoutNode != null && timeoutNode.isNumber())
            timeout = timeoutNode.asInt();

        dataSource.setJdbcUrl(url);
        dataSource.setUsername(user);
        dataSource.setPassword(pass);
        dataSource.setMaximumPoolSize(max);
        dataSource.setMinimumIdle(min);
        dataSource.setIdleTimeout(timeout);
    }

    public Connection pop() throws SQLException {
        Connection conn = this.dataSource.getConnection();

        return conn;
    }
}
