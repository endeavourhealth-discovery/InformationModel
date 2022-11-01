package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ConceptExport {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptExport.class);

    private static final String APP_ID = "ConceptExport";
    private static final String LAST_DBID = "LastDbid";
    private static final Integer BATCH_SIZE = 5000;
    private static final Integer ZIP_BUFFER = 1024 * 32;

    private static ConfigHelper config;

    public static void main(String[] argv) throws Exception {
        if (argv.length != 1) {
            LOG.error("Usage: ConceptExport <folder>");
            System.exit(-1);
        }

        String conceptDir = argv[0];
        if (!conceptDir.endsWith("/"))
            conceptDir += "/";

        LOG.info("Exporting new concepts from IM1");
        LOG.debug("Working directory [{}]", conceptDir);

        config = new ConfigHelper(APP_ID);
        Integer lastDbid = getLastExportedDbidFromConfig();

        Integer newDbid = exportNewData(conceptDir, lastDbid);

        if (newDbid != null && newDbid.equals(lastDbid)) {
            LOG.info("No new concepts");
        } else {
            LOG.warn("New concepts added");
            zipConceptFile(conceptDir);
            pushFileToGit(conceptDir);
            saveLastExportedDbidToConfig(newDbid);
        }

        LOG.info("Export complete");
    }

    private static Integer getLastExportedDbidFromConfig() throws SQLException, JsonProcessingException {
        LOG.debug("Retrieving last exported DBID...");

        Integer dbid = config.get(LAST_DBID, Integer.class);

        if (dbid == null) {
            LOG.warn("First run, exporting all concepts");
        } else {
            LOG.info("Continuing from {}", dbid);
        }

        return dbid;
    }

    private static Integer exportNewData(String conceptFile, Integer startDbid) throws SQLException, IOException {
        LOG.info("Checking for new concepts...");
        StringJoiner sql = new StringJoiner(System.lineSeparator())
            .add("SELECT *")
            .add("FROM concept");

        if (startDbid != null)
            sql.add("WHERE dbid > ?");

        try (Connection conn = getIMv1Connection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString(), ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
             FileWriter fw = new FileWriter(conceptFile + "concepts.txt");
             BufferedWriter bw = new BufferedWriter(fw);
             PrintWriter out = new PrintWriter(bw)) {
            if (startDbid != null)
                stmt.setInt(1, startDbid);

            stmt.setFetchSize(Integer.MIN_VALUE);

            LOG.info("Executing....");
            int count = 0;
            try (ResultSet rs = stmt.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                LOG.info("Fetching....");
                while (rs.next()) {
                    if (++count % BATCH_SIZE == 0)
                        LOG.info("...{}...", count);
                    startDbid = rs.getInt("dbid");
                    StringJoiner row = new StringJoiner("\t");

                    for (int i = 1; i <= meta.getColumnCount(); i++) {
                        row.add(rs.getString(i));
                    }

                    out.println(row);
                }

                LOG.info("{} new concepts", count);
            }
        }

        return startDbid;
    }

    private static Connection getIMv1Connection() throws SQLException, JsonProcessingException {
        LOG.debug("Connecting to IM database...");
        ConnectionConfig v1Conn = config.get("information-model", "database", ConnectionConfig.class);

        return DriverManager.getConnection(v1Conn.getUrl(), v1Conn.getUsername(), v1Conn.getPassword());
    }

    private static void zipConceptFile(String conceptDir) throws IOException {
        LOG.info("Zipping concepts...");
        File fileToZip = new File(conceptDir + "concepts.txt");
        try (FileOutputStream fos = new FileOutputStream(conceptDir + "concepts.zip");
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
    }

    private static void pushFileToGit(String conceptDir) throws IOException, InterruptedException {
        LOG.info("Pushing to GIT");
        git(conceptDir, "pull");
        git(conceptDir, "add", conceptDir + "concepts.zip");


        Date now = new Date();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String commitMessage = "New concepts as of " + sf.format(now);
        git(conceptDir, "commit", "-m", commitMessage);

        git(conceptDir, "push", "-u", "origin", "master");
    }

    private static void git(String conceptDir, String... params) throws IOException, InterruptedException {
        List<String> cmd = new ArrayList<>();
        if (System.getProperty("os.name").toLowerCase().startsWith("windows")) {
            cmd.add("cmd.exe");
            cmd.add("/c");
        } else {
            cmd.add("sh");
            cmd.add("-c");
        }

        cmd.add("git");
        cmd.addAll(Arrays.asList(params));

        LOG.info("Command [{}]", String.join(" ", cmd));

        ProcessBuilder builder = new ProcessBuilder();
        builder.command(cmd);
        builder.directory(new File(conceptDir));

        Process proc = builder.start();
        int exitCode = proc.waitFor();

        LOG.debug(getStreamAsString(proc.getInputStream()));
        LOG.error(getStreamAsString(proc.getErrorStream()));

        if (exitCode != 0) {
            LOG.error("Git command failed - {}", proc.exitValue());
            System.exit(-1);
        }

    }

    private static String getStreamAsString(InputStream is) throws IOException {
        byte b[]=new byte[is.available()];
        is.read(b,0,b.length);
        return new String(b);
    }
    private static void saveLastExportedDbidToConfig(Integer lastDbid) throws SQLException, JsonProcessingException {
        LOG.info("Updating config with latest ID..");
        config.set(LAST_DBID, lastDbid);
    }
}
