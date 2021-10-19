package org.endeavourhealth.im;

public class AWSConfig {
    private String accessKey;
    private String secretKey;
    private String region;
    private String bucket;

    public String getAccessKey() {
        return accessKey;
    }

    public AWSConfig setAccessKey(String accessKey) {
        this.accessKey = accessKey;
        return this;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public AWSConfig setSecretKey(String secretKey) {
        this.secretKey = secretKey;
        return this;
    }

    public String getRegion() {
        return region;
    }

    public AWSConfig setRegion(String region) {
        this.region = region;
        return this;
    }

    public String getBucket() {
        return bucket;
    }

    public AWSConfig setBucket(String bucket) {
        this.bucket = bucket;
        return this;
    }
}
