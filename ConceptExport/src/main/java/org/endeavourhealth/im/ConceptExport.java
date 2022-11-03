package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ConceptExport {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptExport.class);

    private static final String APP_ID = "ConceptExport";
    private static final Integer BATCH_SIZE = 100000;
    private static final Integer ZIP_BUFFER = 1024 * 32;

    private static ConfigHelper config;

    public static void main(String[] argv) throws Exception {
        if (argv.length != 1) {
            LOG.error("Usage: ConceptExport <folder>");
            System.exit(-1);
        }

        config = new ConfigHelper(APP_ID);

        String conceptDir = argv[0];
        if (!conceptDir.endsWith("/"))
            conceptDir += "/";

        LOG.info("Exporting new concepts from IM1");
        LOG.debug("Working directory [{}]", conceptDir);

        cleanupGit(conceptDir);

        int lastDbid = getLastDbidFromConceptFile(conceptDir);
        int currDbid = getLatestDbidFromDatabase();
        int newConcepts = currDbid - lastDbid;

        if (newConcepts < 0) {
            LOG.error("File in GIT has more concepts than database!!");
        } else if (newConcepts == 0) {
            LOG.info("No changes");
        } else {
            LOG.info("{} new concepts added", newConcepts);
            exportNewData(conceptDir);
            zipConceptFile(conceptDir);
            pushFileToGit(conceptDir);
        }
        LOG.info("Finished");
    }

    private static int getLastDbidFromConceptFile(String conceptDir) throws IOException {
        LOG.debug("Retrieving last exported DBID...");

        String lastLine = null;
        try (FileReader fr = new FileReader(conceptDir + "IMv1/concepts.txt");
             BufferedReader br = new BufferedReader(fr)) {

            String current;
            while ((current = br.readLine()) != null) {
                lastLine = current;
            }
        }

        if (lastLine == null) {
            LOG.warn("First run, exporting all concepts");
            return 0;
        } else {
            int dbid = Integer.parseInt(lastLine.split("\t")[0]);
            LOG.info("Latest on git {}", dbid);
            return dbid;
        }
    }

    private static int getLatestDbidFromDatabase() throws SQLException, JsonProcessingException {
        LOG.debug("Retrieving latest DBID from database...");
        try (Connection conn = getIMv1Connection();
             PreparedStatement stmt = conn.prepareStatement("SELECT MAX(dbid) FROM concept");
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                int dbid = rs.getInt(1);
                LOG.info("Latest in database {}", dbid);
                return dbid;
            } else {
                LOG.error("Database table empty!");
                return 0;
            }
        }
    }

    private static void exportNewData(String conceptFile) throws SQLException, IOException {
        LOG.info("Checking for new concepts...");
        StringJoiner sql = new StringJoiner(System.lineSeparator())
            .add("SELECT c.dbid, c.id, c.name, c.description, s.id AS scheme, c.code, c.use_count, c.draft")
            .add("FROM concept c")
            .add("LEFT JOIN concept s ON s.dbid = c.scheme");

        try (Connection conn = getIMv1Connection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString(), ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
             FileWriter fw = new FileWriter(conceptFile + "IMv1/concepts.txt");
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
                        row.add(rs.getString(i));
                    }

                    out.println(row);
                }

                LOG.info("{} new concepts", count);
            }
        }
    }

    private static Connection getIMv1Connection() throws SQLException, JsonProcessingException {
        LOG.debug("Connecting to IM database...");
        ConnectionConfig v1Conn = config.get("information-model", "database", ConnectionConfig.class);

        return DriverManager.getConnection(v1Conn.getUrl(), v1Conn.getUsername(), v1Conn.getPassword());
    }

    private static void cleanupGit(String conceptDir) throws IOException, InterruptedException {
        LOG.info("Cleaning up local GIT repository...");
        // Rollback any local/pending in case of failed previous run
        git("fetch", conceptDir);
        git("reset --hard origin/main", conceptDir);
    }
    private static void zipConceptFile(String conceptDir) throws IOException {
        LOG.info("Zipping concepts...");
        File fileToZip = new File(conceptDir + "IMv1/concepts.txt");
        try (FileOutputStream fos = new FileOutputStream(conceptDir + "IMv1/concepts.zip");
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

        // Stage changed file
        git("add IMv1/concepts.zip", conceptDir);

        // Commit local
        git("commit -m \"ConceptExport\"", conceptDir);

        // Push remote
        git("push -u origin main", conceptDir);
    }

    private static void git(String command, String conceptDir) throws IOException, InterruptedException {
        String gitCmd = "git " + command;
        LOG.debug("Command [{}]", gitCmd);

        Runtime rt = Runtime.getRuntime();
        Process proc = rt.exec(gitCmd, null, new File(conceptDir));
        proc.waitFor();

        LOG.debug(getStreamAsString(proc.getInputStream()));
        LOG.error(getStreamAsString(proc.getErrorStream()));

        if (proc.exitValue() != 0) {
            LOG.error("Git command failed - {}", proc.exitValue());
            System.exit(-1);
        }
    }

    private static String getStreamAsString(InputStream is) throws IOException {
        byte[] b=new byte[is.available()];
        is.read(b,0,b.length);
        return new String(b);
    }
}
