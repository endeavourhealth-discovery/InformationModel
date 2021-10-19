package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.StringJoiner;

public class ConceptExport {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptExport.class);

    private static final String APP_ID = "IMv1Sender";
    private static final String LAST_DBID = "LastDbid";
    private static final String S3_CONFIG = "S3Config";

    private static ConfigHelper config;

    public static void main(String[] argv) throws Exception {
        LOG.info("Exporting latest IM(v1) concept data to S3");
        config = new ConfigHelper(APP_ID);

        LastIdConfig lastIds = getLastExportedDbidsFromConfig();
        exportNewDataToS3SinceDbid(lastIds);
        saveUpdatedLastDbidInConfig(lastIds);

        LOG.info("Export complete");
    }

    private static LastIdConfig getLastExportedDbidsFromConfig() throws SQLException, JsonProcessingException {
        LOG.debug("Retrieving last exported DBID...");

        LastIdConfig lastDbid = config.get(LAST_DBID, LastIdConfig.class);

        if (lastDbid == null) {
            LOG.warn("...not found, defaulting to 0");
            return new LastIdConfig();
        } else {
            LOG.debug("...got:-\n\tConcept: {}\n\tCPO    : {}\n\tCPD    : {}",
                lastDbid.getConcept(),
                lastDbid.getCpo(),
                lastDbid.getCpd()
            );
            return lastDbid;
        }
    }

    private static void exportNewDataToS3SinceDbid(LastIdConfig lastIds) throws SQLException, JsonProcessingException {
        LOG.debug("Retrieving S3 config...");
        AWSConfig s3Config = config.get(S3_CONFIG, AWSConfig.class);
        AWSHelper s3 = new AWSHelper(s3Config);

        String date = new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());

        try (Connection conn = getIMv1Connection()) {
            lastIds.setConcept(exportNewConceptsToS3SinceDbid(lastIds.getConcept(), conn, s3, date));
            lastIds.setCpo(exportNewCPOsToS3SinceDbid(lastIds.getCpo(), conn, s3, date));
            lastIds.setCpd(exportNewCPDsToS3SinceDbid(lastIds.getCpd(), conn, s3, date));
        }
    }

    private static Connection getIMv1Connection() throws SQLException, JsonProcessingException {
        LOG.debug("Connecting to IM database...");
        ConnectionConfig v1Conn = config.get("information-model", "database", ConnectionConfig.class);

        return DriverManager.getConnection(v1Conn.getUrl(), v1Conn.getUsername(), v1Conn.getPassword());
    }

    private static int exportNewConceptsToS3SinceDbid(int lastDbid, Connection conn, AWSHelper s3, String date) throws SQLException {
        LOG.info("Concepts...");
        try (PreparedStatement stmt = conn.prepareStatement("SELECT dbid, id, name, description, scheme, code FROM concept WHERE dbid > ?")) {
            stmt.setInt(1, lastDbid);
            LOG.debug("Running SQL...");
            try (ResultSet rs = stmt.executeQuery()) {
                LOG.debug("Collecting data...");
                StringJoiner data = new StringJoiner("\n");
                data.add(getHeader(rs));

                while(rs.next()) {
                    lastDbid = rs.getInt("dbid");
                    data.add(getRow(rs));
                }

                LOG.debug("Sending to S3...");
                s3.put(date + "_concepts.csv", data.toString());
            }
        }
        return lastDbid;
    }

    private static int exportNewCPOsToS3SinceDbid(int lastDbid, Connection conn, AWSHelper s3, String date) throws SQLException {
        LOG.info("Concept property objects...");
        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM concept_property_object WHERE dbid > ?")) {
            stmt.setInt(1, lastDbid);
            LOG.debug("Running SQL...");
            try (ResultSet rs = stmt.executeQuery()) {
                LOG.debug("Collecting data...");
                StringJoiner data = new StringJoiner("\n");
                data.add(getHeader(rs));

                while (rs.next()) {
                    lastDbid = rs.getInt("dbid");
                    data.add(getRow(rs));
                }

                LOG.debug("Sending to S3...");
                s3.put(date + "_cpo.csv", data.toString());
            }
        }
        return lastDbid;
    }

    private static int exportNewCPDsToS3SinceDbid(int lastDbid, Connection conn, AWSHelper s3, String date) throws SQLException {
        LOG.info("Concept property data..");
        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM concept_property_data WHERE dbid > ?")) {
            stmt.setInt(1, lastDbid);
            LOG.debug("Running SQL...");
            try (ResultSet rs = stmt.executeQuery()) {
                LOG.debug("Collecting data...");
                StringJoiner data = new StringJoiner("\n");
                data.add(getHeader(rs));

                while (rs.next()) {
                    lastDbid = rs.getInt("dbid");
                    data.add(getRow(rs));
                }

                LOG.debug("Sending to S3...");
                s3.put(date + "_cpd.csv", data.toString());
            }
        }
        return lastDbid;
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

    private static void saveUpdatedLastDbidInConfig(LastIdConfig lastDbid) throws SQLException, JsonProcessingException {
        LOG.info("Updating config with latest IDs..");
        config.set(LAST_DBID, lastDbid);
    }
}
