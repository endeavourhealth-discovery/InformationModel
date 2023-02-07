package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.nio.file.Files;
import java.sql.*;
import java.util.StringJoiner;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

public abstract class BaseExporter {
    private static final Logger LOG = LoggerFactory.getLogger(BaseExporter.class);

    protected static final Integer BATCH_SIZE = 100000;
    protected static final Integer ZIP_BUFFER = 1024 * 32;

    private static ConfigHelper config;

    public void execute(String datafile) throws IOException, SQLException {
        execute(datafile, null);
    }
    public void execute(String dataFile, String zipFile) throws IOException, SQLException {
        try (Connection conn = getDbConnection()) {
            if (zipFile != null)
                unzipFile(zipFile, dataFile);

            int fileRows = getRowCountFromFile(dataFile);
            int dbRows = getRowCountFromDatabase(conn);
            int newRows = dbRows - fileRows;

            if (newRows < 0) {
                LOG.error("File in GIT has more rows than database!!");
                System.exit(-1);
            } else if (newRows == 0) {
                LOG.info("No changes");
            } else {
                LOG.info("{} new rows added", newRows);
                exportNewRows(conn, dataFile);

                if (zipFile != null)
                    zipFile(dataFile, zipFile);
            }
        }
    }

    protected Connection getDbConnection(String configId) throws SQLException, JsonProcessingException {
        LOG.debug("Connecting to database...");
        ConnectionConfig v1Conn = getConfig(configId, ConnectionConfig.class);

        if (v1Conn == null) {
            LOG.error("Unknown database configuration {}", configId);
            System.exit(-1);
        }
        return DriverManager.getConnection(v1Conn.getUrl(), v1Conn.getUsername(), v1Conn.getPassword());
    }

    abstract Connection getDbConnection() throws SQLException, JsonProcessingException;

    protected <T> T getConfig(String configId, Class<T> valueType) throws SQLException, JsonProcessingException {
        if (config == null)
            config = new ConfigHelper("concept-export");

        return config.get(configId, valueType);
    }

    protected void unzipFile(String sourceZip, String destFile) throws IOException {
        LOG.info("Unzipping {} to {}...", sourceZip, destFile);
        File fileToUnzip = new File(sourceZip);
        try (FileInputStream fis = new FileInputStream(fileToUnzip);
             ZipInputStream zipIn = new ZipInputStream(fis);
             FileOutputStream fos = new FileOutputStream(destFile)) {

            ZipEntry zipEntry = zipIn.getNextEntry();
            byte[] bytes = new byte[ZIP_BUFFER];
            int length;
            while ((length = zipIn.read(bytes)) >= 0) {
                fos.write(bytes, 0, length);
            }
        }
    }

    private int getRowCountFromFile(String conceptFile) throws IOException {
        LOG.debug("Retrieving row count from file...");

        int rows = 0;
        int colCount = 0;
        try (FileReader fr = new FileReader(conceptFile);
             BufferedReader br = new BufferedReader(fr)) {

            String line;
            while ((line = br.readLine()) != null) {
                int lineCols = line.split("\t").length;
                if (rows == 0) {
                    colCount = lineCols;
                } else {
                    while (lineCols < colCount) {
                        line = br.readLine();
                        lineCols += line.split("\t").length - 1;
                    }
                }
                rows++;
            }
        }
        LOG.debug("...{} rows found", rows);
        return rows;
    }

    int getRowCountFromDatabase(Connection conn) throws SQLException {
        LOG.debug("Retrieving row count from database...");
        try (PreparedStatement stmt = conn.prepareStatement(getRowCountSql());
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                int rows = rs.getInt(1);
                LOG.info("Rows in database {}", rows);
                return rows;
            } else {
                LOG.error("Database table empty!");
                return 0;
            }
        }
    }
    abstract String getRowCountSql();

    protected void exportNewRows(Connection conn, String conceptFile) throws SQLException, IOException {
        LOG.info("Fetching data...");

        try (PreparedStatement stmt = conn.prepareStatement(getNewRowSql(), ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
             FileWriter fw = new FileWriter(conceptFile);
             BufferedWriter bw = new BufferedWriter(fw);
             PrintWriter out = new PrintWriter(bw)) {

            stmt.setFetchSize(Integer.MIN_VALUE);

            LOG.info("Executing....");
            int count = 0;
            try (ResultSet rs = stmt.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                LOG.info("Fetching....");
                while (rs.next()) {
                    if (++count % BATCH_SIZE == 0)
                        LOG.trace("...{}...", count);

                    StringJoiner row = new StringJoiner("\t");

                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        String v = rs.getString(i);
                        if (v == null)
                            row.add("NULL");
                        else
                            row.add(rs.getString(i).replace("\t", "\\t").replace("\n", "\\n"));
                    }

                    out.println(row);
                }

                LOG.info("{} rows", count);
            }
        }
    }
    abstract String getNewRowSql();

    protected void zipFile(String sourceFile, String destZip) throws IOException {
        LOG.info("Zipping {} to {}...", sourceFile, destZip);
        File fileToZip = new File(sourceFile);
        try (FileOutputStream fos = new FileOutputStream(destZip);
             ZipOutputStream zipOut = new ZipOutputStream(fos);
             FileInputStream fis = new FileInputStream(fileToZip)) {

            ZipEntry zipEntry = new ZipEntry(fileToZip.getName());
            zipOut.putNextEntry(zipEntry);
            byte[] bytes = new byte[ZIP_BUFFER];
            int length;
            while ((length = fis.read(bytes)) >= 0) {
                zipOut.write(bytes, 0, length);
            }
        }
        Files.delete(fileToZip.toPath());
    }
}
