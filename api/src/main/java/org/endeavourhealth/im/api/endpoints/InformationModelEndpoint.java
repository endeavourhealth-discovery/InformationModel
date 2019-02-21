package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.dal.InformationModelJDBCDAL;
import org.endeavourhealth.im.models.Concept;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.ArrayList;
import java.util.List;

@Path("IM")
@Metrics(registry = "ConceptMetricRegistry")
@Api(tags = {"Concept"})
public class InformationModelEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(InformationModelEndpoint.class);

    /******************** CONCEPTS ********************/
    @GET
    @Path("/MRU")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.MRU.GET")
    @ApiOperation(value = "List of tokens matching the search term", response = Concept.class)
    public Response MRU(@Context SecurityContext sc) throws Exception {
        LOG.debug("Get concept by ID");

        List<Concept> result = new InformationModelJDBCDAL().mru();

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Search")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Search.GET")
    @ApiOperation(value = "List of tokens matching the search term", response = Concept.class)
    public Response search(@Context SecurityContext sc,
                           @ApiParam(value = "Concept ID", required = true) @QueryParam("term") String term) throws Exception {
        LOG.debug("Get concept by ID");

        List<Concept> result = new InformationModelJDBCDAL().search(term);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.GET")
    @ApiOperation(value = "Returns concept by ID", response = Concept.class)
    public Response get(@Context SecurityContext sc,
                        @ApiParam(value = "Concept ID", required = true) @PathParam("id") String id) throws Exception {
        LOG.debug("Get concept by ID");

        String result = new InformationModelJDBCDAL().get(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/{id}/name")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.name.GET")
    @ApiOperation(value = "Returns concept name by ID", response = String.class)
    public Response getName(@Context SecurityContext sc,
                        @ApiParam(value = "Concept ID", required = true) @PathParam("id") String id) throws Exception {
        LOG.debug("Get concept name by ID");

        String result = new InformationModelJDBCDAL().getName(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.POST")
    @ApiOperation(value = "Saves a concept")
    public Response post(@Context SecurityContext sc,
                         String json) throws Exception {
        LOG.debug("Save concept");

        new InformationModelJDBCDAL().saveConcept(json);

        return Response
            .ok()
            .build();
    }

    @GET
    @Path("/document")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.document.GET")
    @ApiOperation(value = "Returns list of document IRIs", response = String.class, responseContainer = "List")
    public Response getDocuments(@Context SecurityContext sc) throws Exception {
        LOG.debug("Get documents");

        List<String> result = new InformationModelJDBCDAL().getDocuments();

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Path("/ValidateIds")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.ValidateIds.POST")
    @ApiOperation(value = "Validates concept ids")
    public Response validateIds(@Context SecurityContext sc, List<String> ids) throws Exception {
        LOG.debug("Validate ids");

//        List<String> ids = new ArrayList<>();
//        ids.add(id);

        String result = new InformationModelJDBCDAL().validateIds(ids);

        return Response
            .ok()
            .entity(result)
            .build();
    }
}
