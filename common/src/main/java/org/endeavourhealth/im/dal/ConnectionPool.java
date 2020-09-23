package org.endeavourhealth.im.dal;

import com.fasterxml.jackson.databind.JsonNode;
import com.zaxxer.hikari.HikariDataSource;
import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.coreui.framework.ContextShutdownHook;
import org.endeavourhealth.coreui.framework.StartupConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;

public class ConnectionPool implements ContextShutdownHook {
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

        dataSource.setJdbcUrl(url);
        dataSource.setUsername(user);
        dataSource.setPassword(pass);

        JsonNode max = json.get("max");
        if (max != null && max.isNumber())
            dataSource.setMaximumPoolSize(max.asInt());

        StartupConfig.registerShutdownHook("Hikari connection pool", this);
    }

    public Connection pop() throws SQLException {
        LOG.debug("Connection popped from pool");

        Connection conn = this.dataSource.getConnection();

        MetricsHelper.recordValue("ConnectionPool.Size", dataSource.getHikariPoolMXBean().getTotalConnections());
        MetricsHelper.recordValue("ConnectionPool.Active", dataSource.getHikariPoolMXBean().getActiveConnections());

        return conn;
    }

    @Override
    public void contextShutdown() {
        LOG.debug("Clearing Hikari pool");

        int size = dataSource.getHikariPoolMXBean().getActiveConnections();
        if (size > 0)
            LOG.warn(size + "connections still active!");

        size = dataSource.getHikariPoolMXBean().getTotalConnections();
        LOG.debug("Closing " + size + " connections in pool");

        dataSource.close();
    }
}
