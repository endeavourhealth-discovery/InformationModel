package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.logic.ConceptLogic;
import org.endeavourhealth.im.common.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("Concept")
@Metrics(registry = "ConceptMetricRegistry")
@Api(description = "API for all calls relating to Concepts")
public class ConceptEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptEndpoint.class);

    @GET
    @Path("/MRU")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.MRU.GET")
    @ApiOperation(value = "Returns summary of most recently used concepts")
    public Response mru(@Context SecurityContext sc) throws Exception {
        LOG.debug("Get concept MRU");

        ConceptSummaryList result = new ConceptLogic().getMRU();

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
    @ApiOperation(value = "Returns summary of most recently used concepts")
    public Response search(@Context SecurityContext sc,
                           @ApiParam(value = "Search term") @QueryParam("searchTerm") String searchTerm) throws Exception {
        LOG.debug("Search concepts");

        ConceptSummaryList result = new ConceptLogic().search(searchTerm);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.GET")
    @ApiOperation(value = "Returns Concept by id")
    public Response get(@Context SecurityContext sc,
                        @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get concept");

        Concept result = new ConceptLogic().get(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.POST")
    @ApiOperation(value = "Saves a concept")
    public Response save(@Context SecurityContext sc,
                         @ApiParam(value = "Concept to save") Concept concept
    ) throws Exception {
        LOG.debug("Save concept");

        Long id = new ConceptLogic().save(concept);

        return Response
            .ok(id)
            .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Bundle")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Bundle.GET")
    @ApiOperation(value = "Returns Concept bundle by id")
    public Response getBundle(@Context SecurityContext sc,
                        @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get concept");

        ConceptBundle result = new ConceptLogic().getBundle(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }
//
//    @GET
//    @Consumes(MediaType.APPLICATION_JSON)
//    @Produces(MediaType.APPLICATION_JSON)
//    @Path("/Attribute")
//    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attribute.GET")
//    @ApiOperation(value = "Returns a list of attributes of a concept")
//    public Response getAttributes(@Context SecurityContext sc,
//                                  @ApiParam(value = "Concept Id") @QueryParam("id") Long id
//    ) throws Exception {
//        LOG.debug("Get concept attributes");
//
//        List<Attribute> result = new ConceptLogic().getAttributes(id);
//
//        return Response
//            .ok()
//            .entity(result)
//            .build();
//    }


    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/RelatedTargets")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.RelatedTargets.GET")
    @ApiOperation(value = "Returns related target concepts by id")
    public Response getRelatedTargets(@Context SecurityContext sc,
                                      @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get related target concepts");

        List<RelatedConcept> result = new ConceptLogic().getRelatedTargets(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/RelatedSources")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.RelatedSources.GET")
    @ApiOperation(value = "Returns related source concepts by id")
    public Response getRelatedSources(@Context SecurityContext sc,
                                      @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get related source concepts");

        List<RelatedConcept> result = new ConceptLogic().getRelatedSources(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Relationships")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Relationships.GET")
    @ApiOperation(value = "Returns a list of relationship concepts")
    public Response getRelationships(@Context SecurityContext sc) throws Exception {
        LOG.debug("Get relationship concepts");

        List<ConceptReference> result = new ConceptLogic().getRelationships();

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Bundle")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Bundle.POST")
    @ApiOperation(value = "Saves a concept bundle")
    public Response saveBundle(@Context SecurityContext sc,
                         @ApiParam(value = "Concept to save") ConceptBundle conceptBundle
    ) throws Exception {
        LOG.debug("Save concept bundle");

        new ConceptLogic().save(conceptBundle);

        return Response
            .ok()
            .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Rules/Execute")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Calculate.GET")
    @ApiOperation(value = "Returns Concept by JSON")
    public Response calculate(@Context SecurityContext sc,
                        @ApiParam(value = "Root Concept Id") @QueryParam("conceptId") Long conceptId,
                        @ApiParam(value = "Create task") @QueryParam("createTask") Boolean createTask,
                        @ApiParam(value = "JSON") String json
    ) throws Exception {
        LOG.debug("Get execute rules for concept");

        CalculationResult result = new ConceptLogic().calculate(json, conceptId, createTask == null ? false : createTask);

        return Response
            .ok()
            .entity(result)
            .build();
    }
}