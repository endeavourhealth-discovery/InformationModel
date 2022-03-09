package org.endeavourhealth.im.imv2receiver;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectListing;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.amazonaws.services.s3.model.S3ObjectSummary;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class SetImporter {
    private static final Logger LOG = LoggerFactory.getLogger(SetImporter.class);
    private String bucket = "im-inbound-dev";
    private String region = "eu-west-2";
    S3ObjectInputStream inputStream = null;

    public void getSetFromIM2() throws ConfigManagerException, SQLException, IOException {
        ConfigManager.Initialize("IMv2Receiver");

        AmazonS3 s3 = getS3Client();

        List<String> filenames = getFileNamesFromS3(s3);

        sortFileNames(filenames);

        importFiles(s3, filenames);

        LOG.debug("Done");
    }

    private AmazonS3 getS3Client() throws IOException {
        String accessKey = "";
        String secretKey = "";

        try {
            JsonNode config = ConfigManager.getConfigurationAsJson("S3Config");
            if (config == null) {
                LOG.debug("No S3 config found, reverting to defaults");
            } else {
                bucket = config.get("bucket").asText();
                region = config.get("region").asText();
                accessKey = config.get("accessKey").asText();
                secretKey = config.get("secretKey").asText();
            }
        } catch (JsonProcessingException e) {
            LOG.debug("No S3 config found, reverting to defaults");
        }

        BasicAWSCredentials awsCredentials = new BasicAWSCredentials(accessKey, secretKey);
        return AmazonS3ClientBuilder
            .standard()
            .withRegion(region)
            .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
            .build();
    }

    private List<String> getFileNamesFromS3(AmazonS3 s3) {
        List<String> filenames = new ArrayList<>();

        ObjectListing objectsList = listObjects(bucket, s3);

        for (S3ObjectSummary os : objectsList.getObjectSummaries()) {
            filenames.add(os.getKey());
        }

        return filenames;
    }

    protected ObjectListing listObjects(String bucket, AmazonS3 s3) {
        ObjectListing objectsList = new ObjectListing();

        LOG.debug("Listing all objects in S3");
        objectsList = s3.listObjects(bucket);

        return objectsList;
    }

    protected void sortFileNames(List<String> filenames) {
        filenames.sort(Comparator.comparing(this::getTimestamp));
    }

    private String getTimestamp(String filename) {
        return filename.substring(0, filename.indexOf("_"));
    }

    private void importFiles(AmazonS3 s3, List<String> filenames) throws IOException, SQLException {
        try (Connection conn = Objects.requireNonNull(ConnectionPool.getInstance()).pop();
             PreparedStatement vsSelect = conn.prepareStatement("SELECT v.dbid FROM value_set v WHERE v.id = ?");
             PreparedStatement vsInsert = conn.prepareStatement("INSERT INTO value_set (id, name) VALUES (?, ?)");
             PreparedStatement vsmDelete = conn.prepareStatement("DELETE FROM value_set_member WHERE value_set = ?");
             PreparedStatement vsmInsert = conn.prepareStatement("INSERT INTO value_set_member (value_set, concept) VALUES (?, ?)")
        ) {
            for (String filename : filenames) {
                inputStream = DownloadFile(bucket, s3, filename);
                processStream(inputStream, vsSelect, vsInsert, vsmDelete, vsmInsert);
                DeleteFile(bucket, s3, filename);
            }
        }
    }

    protected S3ObjectInputStream DownloadFile(String bucket, AmazonS3 s3, String filename) {
        LOG.debug("Downloading " + filename + " from S3");
        S3Object s3object = s3.getObject(bucket, filename);
        return s3object.getObjectContent();
    }

    private void processStream(S3ObjectInputStream inputStream,
                               PreparedStatement vsSelect,
                               PreparedStatement vsInsert,
                               PreparedStatement vsmDelete,
                               PreparedStatement vsmInsert) throws IOException, SQLException {
        LOG.debug("processing");
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        reader.readLine();      // NOSONAR - Skip header
        String line = reader.readLine();
        String currentSetId = "";
        int valueSetDbid = 0;
        int setCount = 0;
        while (line != null && !line.isEmpty()) {
            String[] fields = line.split("\t");
            String setId = fields[0];
            String setName = fields[1];
            int memberDbid = Integer.parseInt(fields[2]);

            // Are we onto a different set?
            if (!currentSetId.equals(setId)) {
                if (setCount > 0)
                    LOG.debug("Finished {} members", setCount);

                LOG.debug("ValueSet : {}", setId);

                currentSetId = setId;
                setCount = 0;
                // Get/create set ID
                valueSetDbid = getValueSetDbid(vsSelect, setId);
                if (valueSetDbid == 0) {
                    insertValueSet(vsInsert, setId, setName);
                    valueSetDbid = getValueSetDbid(vsSelect, setId);
                }
                // Delete any existing members
                deleteMembers(vsmDelete, valueSetDbid);
            }

            insertValueSetMember(vsmInsert, valueSetDbid, memberDbid);

            if (++setCount % 5000 == 0)
                LOG.debug("Imported {} members", setCount);

            line = reader.readLine();
        }
        LOG.debug("Finished {} members", setCount);
    }

    private int getValueSetDbid(PreparedStatement vsSelect, String setId) throws SQLException {
        int setDbid = 0;

        vsSelect.setString(1, setId);
        try (ResultSet rs = vsSelect.executeQuery()) {
            while (rs.next()) {
                setDbid = rs.getInt("dbid");
            }
        }

        return setDbid;
    }

    private void insertValueSet(PreparedStatement vsInsert, String setId, String setName) throws SQLException {
        vsInsert.setString(1, setId);
        vsInsert.setString(2, setName);
        vsInsert.executeUpdate();
    }

    private void deleteMembers(PreparedStatement vsmDelete, int setDbid) throws SQLException {
        vsmDelete.setInt(1, setDbid);
        vsmDelete.executeUpdate();
    }

    private void insertValueSetMember(PreparedStatement vsmInsert, int setDbid, int memberDbid) throws SQLException {
        vsmInsert.setInt(1, setDbid);
        vsmInsert.setInt(2, memberDbid);
        vsmInsert.executeUpdate();
    }

    private void DeleteFile(String bucket, AmazonS3 s3, String filename) {
        LOG.debug("Deleting " + filename + " from S3");
        s3.deleteObject(bucket, filename);
    }
}
