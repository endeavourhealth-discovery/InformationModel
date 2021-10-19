package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.StringJoiner;

public class ConceptExport {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptExport.class);

    private static final String APP_ID = "IMv1Sender";
    private static final String LAST_DATE = "LastDate";
    private static final String S3_CONFIG = "S3Config";

    private static ConfigHelper config;
    private static AWSHelper s3;
    private static Date lastExport;
    private static Date now;
    private static String baseName;

    public static void main(String[] argv) throws Exception {
        LOG.info("Exporting latest IM(v1) concept data to S3");

        config = new ConfigHelper(APP_ID);
        s3 = getS3Helper();
        lastExport = getLastExportedDateTimeFromConfig();
        now = new Date();
        SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
        baseName = sf.format(lastExport) + "-" + sf.format(now) + "_";

        exportNewDataToS3BetweenDates();

        saveLastExportedDateTimeToConfig();

        LOG.info("Export complete");
    }

    private static AWSHelper getS3Helper() throws SQLException, JsonProcessingException {
        LOG.debug("Retrieving S3 config...");
        AWSConfig s3Config = config.get(S3_CONFIG, AWSConfig.class);
        return new AWSHelper(s3Config);
    }

    private static Date getLastExportedDateTimeFromConfig() throws SQLException, JsonProcessingException {
        LOG.debug("Retrieving last exported DateTime...");

        Date lastDbid = config.get(LAST_DATE, Date.class);

        if (lastDbid == null) {
            LOG.warn("...not found, defaulting to 1-Jan-1970");
            return new Date(0);
        } else {
            LOG.debug("...got:-{}", lastDbid);
            return lastDbid;
        }
    }

    private static void exportNewDataToS3BetweenDates() throws SQLException, JsonProcessingException {
        try (Connection conn = getIMv1Connection()) {
            exportQueryResultsToS3BetweenDates(conn, "concept");
            exportQueryResultsToS3BetweenDates(conn, "concept_property_object");
            exportQueryResultsToS3BetweenDates(conn, "concept_property_data");
        }
    }

    private static Connection getIMv1Connection() throws SQLException, JsonProcessingException {
        LOG.debug("Connecting to IM database...");
        ConnectionConfig v1Conn = config.get("information-model", "database", ConnectionConfig.class);

        return DriverManager.getConnection(v1Conn.getUrl(), v1Conn.getUsername(), v1Conn.getPassword());
    }

    private static void exportQueryResultsToS3BetweenDates(Connection conn, String table) throws SQLException {
        LOG.info("Exporting from {}...", table);

        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM " + table + " WHERE updated BETWEEN ? AND ?")) {
            stmt.setDate(1, new java.sql.Date(lastExport.getTime()));
            stmt.setDate(2, new java.sql.Date(now.getTime()));
            LOG.debug("Running SQL...");
            try (ResultSet rs = stmt.executeQuery()) {
                LOG.debug("Collecting data...");
                StringJoiner data = new StringJoiner("\n");
                data.add(getHeader(rs));

                while(rs.next()) {
                    data.add(getRow(rs));
                }

                LOG.debug("Sending to S3...");
                s3.put(baseName + table + ".csv", data.toString());
            }
        }
    }

    private static String getHeader(ResultSet resultSet) throws SQLException {
        ResultSetMetaData meta = resultSet.getMetaData();
        int cols = meta.getColumnCount();

        StringJoiner row = new StringJoiner("\t");

        for (int i = 1; i <= cols; i++)
            row.add(meta.getColumnName(i));

        return row.toString();
    }

    private static String getRow(ResultSet resultSet) throws SQLException {
        ResultSetMetaData meta = resultSet.getMetaData();
        int cols = meta.getColumnCount();

        StringJoiner row = new StringJoiner("\t");

        for (int i = 1; i <= cols; i++) {
            String cell = resultSet.getString(i);
            row.add(resultSet.wasNull() ? "" : cell);
        }

        return row.toString();
    }

    private static void saveLastExportedDateTimeToConfig() throws SQLException, JsonProcessingException {
        LOG.info("Updating config with latest ID..");
        config.set(LAST_DATE, new SimpleDateFormat("'\"'yyyy-MM-dd'T'HH:mm:ss'\"'").format(now));
    }
}
