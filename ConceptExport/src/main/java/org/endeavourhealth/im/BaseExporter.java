package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Paths;
import java.sql.*;
import java.util.StringJoiner;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public abstract class BaseExporter {
    private static final Logger LOG = LoggerFactory.getLogger(BaseExporter.class);

    protected static final Integer BATCH_SIZE = 100000;
    protected static final Integer ZIP_BUFFER = 1024 * 32;

    private static ConfigHelper config;

    public int execute(String dataFile, String zipFile, File workDir) throws IOException, SQLException, InterruptedException {
        try (Connection conn = getDbConnection()) {
            if (zipFile != null)
                unzipFile(zipFile, dataFile);

            int fileRows = getRowCountFromFile(dataFile);
            int dbRows = getRowCountFromDatabase(conn);
            int newRows = dbRows - fileRows;

            if (newRows == 0) {
                LOG.info("No changes");
                return 0;
            }

            if (newRows < 0) {
                LOG.warn("Rows in database appears to have reduced from {} to {} ({})", fileRows, dbRows, newRows);
            } else {
                LOG.info("{} new rows added", newRows);
            }

            exportNewRows(conn, dataFile);

            if (zipFile != null)
                zipFile(dataFile, zipFile, workDir);

            return newRows;
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

    protected void zipFile(String sourceFile, String destZip, File workDir) throws IOException, InterruptedException {
        deleteZipParts(destZip);

        LOG.info("Zipping {} to {}...", sourceFile, destZip);
        String zipCmd = "zip -s 25m " + destZip + " " + sourceFile;
        if (execCmd(zipCmd, workDir) != 0) {
            LOG.error("Zip command failed!");
            System.exit(-1);
        }

        File fileToZip = new File(sourceFile);
        Files.delete(fileToZip.toPath());
    }

    static void deleteZipParts(String zipFile) throws IOException {
        File zip = new File(zipFile);
        File zipPath = new File(zip.getParent());
        final String delPattern = zip.getName().substring(0, zip.getName().length() - 4) + ".z";
        LOG.info("Removing files matching {}/{}*", zipPath, delPattern);
        for (File f: zipPath.listFiles((d,f) -> f.startsWith(delPattern))) {
            LOG.info("Deleting {} ...", f);
            Files.delete(f.toPath());
        }
    }

    static int execCmd(String command, File workingDir) throws InterruptedException, IOException {
        Runtime rt = Runtime.getRuntime();

        Process proc = rt.exec(command, null, workingDir);
        proc.waitFor();

        String output = getStreamAsString(proc.getInputStream());
        if (!output.isEmpty())
            LOG.debug(output);

        String error = getStreamAsString(proc.getErrorStream());
        if (!error.isEmpty())
            LOG.error(error);

        return proc.exitValue();
    }

    static String getStreamAsString(InputStream is) throws IOException {
        byte[] b=new byte[is.available()];
        is.read(b,0,b.length);
        return new String(b);
    }

}
