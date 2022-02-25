package org.endeavourhealth.im.imv2receiver;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.AnonymousAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import io.findify.s3mock.S3Mock;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.Arrays;
import java.util.List;

public class SetImporterTest {

    private SetImporter setImporter;
    private AmazonS3 s3;
    private S3Mock api;


    @Before
    public void setup() {

        this.setImporter = new SetImporter();

        /*
        S3Mock.create(8001, "/tmp/s3");
        */

        api = new S3Mock.Builder().withPort(8001).withInMemoryBackend().build();
        api.start();

        /* AWS S3 client setup.
         *  withPathStyleAccessEnabled(true) trick is required to overcome S3 default
         *  DNS-based bucket access scheme
         *  resulting in attempts to connect to addresses like "bucketname.localhost"
         *  which requires specific DNS setup.
         */
        AwsClientBuilder.EndpointConfiguration endpoint = new AwsClientBuilder.EndpointConfiguration("http://localhost:8001", "eu-west-2");
        s3 = AmazonS3ClientBuilder
                .standard()
                .withPathStyleAccessEnabled(true)
                .withEndpointConfiguration(endpoint)
                .withCredentials(new AWSStaticCredentialsProvider(new AnonymousAWSCredentials()))
                .build();

        s3.createBucket("testbucket");
        s3.putObject("testbucket", "2022.02.25.11:45:00_valueset.tsv", "http://endhealth.info/im#VSET_371\tConcept set - Referral\t12573\n" +
                "http://endhealth.info/im#CSET_Covid0\tCovid related value sets\t76895");
    }

    @Test
    public void sortFilenames(){
        List<String> filenames = Arrays.asList("2021.02.10.10:15:20_", "2021.02.10.10:20:20_","2021.03.05.08:30:00_", "2021.02.10.10:05:20_");
        setImporter.sortFileNames(filenames);
        System.out.println(filenames);
        Assert.assertEquals(filenames, Arrays.asList("2021.02.10.10:05:20_", "2021.02.10.10:15:20_", "2021.02.10.10:20:20_","2021.03.05.08:30:00_"));
    }

    @Test
    public void listObjects() {
        String actual = setImporter.listObjects("testbucket", s3).getObjectSummaries().get(0).getKey();
        String filename = "2022.02.25.11:45:00_valueset.tsv";
        System.out.println(actual);
        Assert.assertEquals(filename,actual);
    }

    @After
    public void closeDown() {
        api.shutdown(); // kills the underlying actor system. Use api.stop() to just unbind the port.
    }


}