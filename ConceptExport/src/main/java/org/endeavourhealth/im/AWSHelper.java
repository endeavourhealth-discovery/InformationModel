package org.endeavourhealth.im;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AWSHelper {
    private static final Logger LOG = LoggerFactory.getLogger(AWSHelper.class);

    private final String bucket;
    private final AmazonS3 s3Client;

    public AWSHelper(AWSConfig config) {
        this.bucket = config.getBucket();
        BasicAWSCredentials creds = new BasicAWSCredentials(config.getAccessKey(), config.getSecretKey());
        LOG.debug("Initializing AWS S3 client");
        this.s3Client = AmazonS3ClientBuilder.standard()
            .withCredentials(new AWSStaticCredentialsProvider(creds))
            .withRegion(config.getRegion())
            .build();
    }

    public void put(String key, String data) {
        LOG.debug("Uploading data to bucket");
        s3Client.putObject(bucket, key, data);
    }
}
