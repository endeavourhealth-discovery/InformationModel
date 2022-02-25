package org.endeavourhealth.im.imv2receiver;

import com.amazonaws.AmazonServiceException;
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
import org.endeavourhealth.im.dal.ConnectionPool;
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
    S3ObjectInputStream inputStream = null;

    public void getSetFromIM2() throws ConfigManagerException, SQLException, IOException {
        ConfigManager.Initialize("IMv2Receiver");
        getFilesFromS3();
    }

    private void getFilesFromS3() throws IOException, SQLException {
        List<String> filenames = new ArrayList<>();

        String bucket = "im-inbound-dev";
        String region = "eu-west-2";
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
        final AmazonS3 s3 = AmazonS3ClientBuilder
                .standard()
                .withRegion(region)
                .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
                .build();

        ObjectListing objectsList = listObjects(bucket, s3);

        for(S3ObjectSummary os : objectsList.getObjectSummaries()) {
            filenames.add(os.getKey());
        }
        sortFileNames(filenames);

        for(String filename:filenames){
            inputStream = DownloadFile(bucket, s3, filename);
            readFile(inputStream);
            DeleteFile(bucket, s3, filename);
        }

    }

    public ObjectListing listObjects(String bucket, AmazonS3 s3) {
        ObjectListing objectsList = new ObjectListing();
        try{
            LOG.debug("Listing all objects in S3");
            objectsList = s3.listObjects(bucket);
        } catch (AmazonServiceException e) {
            LOG.error(e.getErrorMessage());
        }
        return objectsList;
    }

    public void sortFileNames(List<String> filenames){
        filenames.sort(Comparator.comparing(this::getTimestamp));
    }

    private String getTimestamp(String filename) {
        return filename.substring(0, filename.indexOf("_"));
    }

    public S3ObjectInputStream DownloadFile(String bucket, AmazonS3 s3, String filename) {
        try{
            LOG.debug("Downloading " + filename + " from S3");
            S3Object s3object = s3.getObject(bucket, filename);
            inputStream = s3object.getObjectContent();
        } catch (AmazonServiceException e) {
            LOG.error(e.getErrorMessage());
        }
        return inputStream;

    }

    private void DeleteFile(String bucket, AmazonS3 s3, String filename) {
        try{
            LOG.debug("Deleting " + filename + " from S3");
            s3.deleteObject(bucket, filename);
        } catch (AmazonServiceException e) {
            LOG.error(e.getErrorMessage());
        }
    }

    private void readFile(S3ObjectInputStream inputStream) throws IOException, SQLException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        String line = reader.readLine();
        while (line != null && !line.isEmpty()){
            String[] fields = line.split("\t");
            String setId = fields[0];
            String setName = fields[1];
            int memberDbid = Integer.parseInt(fields[2]);
            int valueSetDbid = getValueSetDbid(setId);
            if(valueSetDbid == 0){
                insertValueSet(setId,setName);
                valueSetDbid = getValueSetDbid(setId);
            }
            insertValueSetMember(valueSetDbid, memberDbid);
            line = reader.readLine();
        }
    }

    private int getValueSetDbid(String setId) throws SQLException {

        int setDbid = 0;

        String sql = "SELECT v.dbid FROM value_set v WHERE v.id = ?";
        try (Connection conn = Objects.requireNonNull(ConnectionPool.getInstance()).pop();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, setId);
            try (ResultSet rs = stmt.executeQuery()) {
                while(rs.next()){
                    setDbid =  rs.getInt("dbid");
                }
            }
        }
        return setDbid;
    }

    private void insertValueSet(String setId, String setName) throws SQLException {

        String sql = "INSERT INTO value_set (id, name) VALUES (?, ?)";
        try(Connection conn = Objects.requireNonNull(ConnectionPool.getInstance()).pop();
            PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setString(1, setId);
            stmt.setString(2, setName);
            stmt.executeUpdate();
        }
    }

    private void insertValueSetMember(int setDbid, int memberDbid) throws SQLException {

        String sql = "INSERT INTO value_set_member (value_set, member) VALUES (?, ?)";
        try(Connection conn = Objects.requireNonNull(ConnectionPool.getInstance()).pop();
            PreparedStatement stmt = conn.prepareStatement(sql)){
            stmt.setInt(1, setDbid);
            stmt.setInt(2, memberDbid);
            stmt.executeUpdate();
        }
    }

}
