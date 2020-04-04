package org.endeavourhealth.im.api.protectedendpoints;

import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.endeavourhealth.im.dal.IMManagementJDBCDAL;
import org.endeavourhealth.im.models.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.zip.DataFormatException;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

@Path("/")
public class ManagementEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ManagementEndpoint.class);

    @GET
    @Path("/status")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response getStatus(@Context SecurityContext sc) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Management.getStatus")) {
            LOG.debug("getStatus");

            String result = new IMManagementJDBCDAL().getStatus();

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/documents")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDocuments(@Context SecurityContext sc) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Management.getDocuments")) {
            LOG.debug("getDocuments");

            List<Document> result = new IMManagementJDBCDAL().getDocuments();

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @POST
    @Path("/documents")
    @Consumes(MediaType.APPLICATION_OCTET_STREAM)
    @Produces(MediaType.TEXT_PLAIN)
    public Response importDocument(@Context SecurityContext sc, byte[] documentData) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Management.importDocument")) {
            LOG.debug("importDocument");

            String document = new String(decompress(documentData));

            String result = new IMManagementJDBCDAL().importDocument(document);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/documents/{part: .*}/drafts")
    @Consumes(MediaType.APPLICATION_OCTET_STREAM)
    @Produces(MediaType.TEXT_PLAIN)
    public Response getDocumentDrafts(@Context SecurityContext sc,
                                      @PathParam("part") String documentPath) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Management.getDocumentDrafts")) {
            LOG.debug("getDrafts [" + documentPath + "]");

            String json = new IMManagementJDBCDAL().getDocumentDrafts(documentPath);
            byte[] result = compress(json.getBytes());

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    public static byte[] compress(byte[] data) throws IOException {
        Deflater deflater = new Deflater(Deflater.BEST_COMPRESSION);
        deflater.setInput(data);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
        deflater.finish();
        byte[] buffer = new byte[1024];
        while (!deflater.finished()) {
            int count = deflater.deflate(buffer); // returns the generated code... index
            outputStream.write(buffer, 0, count);
        }
        outputStream.close();
        byte[] output = outputStream.toByteArray();
        return output;
    }
    public static byte[] decompress(byte[] data) throws IOException, DataFormatException {
        Inflater inflater = new Inflater();
        inflater.setInput(data);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream(data.length);
        byte[] buffer = new byte[1024];
        while (!inflater.finished()) {
            int count = inflater.inflate(buffer);
            outputStream.write(buffer, 0, count);
        }
        outputStream.close();
        byte[] output = outputStream.toByteArray();
        return output;
    }
}
