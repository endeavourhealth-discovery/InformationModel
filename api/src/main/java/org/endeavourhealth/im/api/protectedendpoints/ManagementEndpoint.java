package org.endeavourhealth.im.api.protectedendpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
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
@Metrics(registry = "ManagementMetricRegistry")
@Api(tags = {"Management"})
public class ManagementEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ManagementEndpoint.class);

    @GET
    @Path("/status")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ManagementEndpoint.Status.GET")
    @ApiOperation(value = "Get the current status of this instance", response = Integer.class)
    public Response getStatus(@Context SecurityContext sc) throws Exception {
        LOG.debug("getStatus");

        String result = new IMManagementJDBCDAL().getStatus();

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/documents")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ManagementEndpoint.Documents.GET")
    @ApiOperation(value = "Get the current documents of this instance", response = Integer.class)
    public Response getDocuments(@Context SecurityContext sc) throws Exception {
        LOG.debug("getDocuments");

        List<Document> result = new IMManagementJDBCDAL().getDocuments();

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Path("/documents")
    @Consumes(MediaType.APPLICATION_OCTET_STREAM)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ManagementEndpoint.Document.POST")
    @ApiOperation(value = "Imports a document from master", response = Integer.class)
    public Response importDocument(@Context SecurityContext sc, byte[] documentData) throws Exception {
        LOG.debug("importDocument");

        String document = new String(decompress(documentData));

        String result = new IMManagementJDBCDAL().importDocument(document);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/documents/{part: .*}/drafts")
    @Consumes(MediaType.APPLICATION_OCTET_STREAM)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ManagementEndpoint.Documents.{path}.Drafts.GET")
    @ApiOperation(value = "Imports a document from master", response = Integer.class)
    public Response getDocumentDrafts(@Context SecurityContext sc,
                                      @PathParam("part") String documentPath) throws Exception {
        LOG.debug("getDrafts [" + documentPath + "]");

        String json = new IMManagementJDBCDAL().getDocumentDrafts(documentPath);
        byte[] result = compress(json.getBytes());

        return Response
            .ok()
            .entity(result)
            .build();
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
