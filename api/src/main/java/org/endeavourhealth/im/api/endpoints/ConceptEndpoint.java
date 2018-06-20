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

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Attribute")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attribute.GET")
    @ApiOperation(value = "Returns a list of attributes of a concept")
    public Response getAttributes(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get concept attributes");

        List<Attribute> result = new ConceptLogic().getAttributes(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }


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
    public Response save(@Context SecurityContext sc,
                         @ApiParam(value = "Concept to save") ConceptBundle conceptBundle
    ) throws Exception {
        LOG.debug("Save concept bundle");

        new ConceptLogic().save(conceptBundle);

        return Response
            .ok()
            .build();
    }
    /*














    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Summaries")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Get")
    @ApiOperation(value = "Returns Concept by id")
    public Response getSummaries(@Context SecurityContext sc,
                                 @ApiParam(value = "Page number") @QueryParam("page") Integer page
    ) throws Exception {
        LOG.debug("Get concept summaries");

        List<ConceptSummary> concepts = new ConceptLogic().getSummaries(page);

        return Response
            .ok()
            .entity(concepts)
            .build();
    }





    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/AttributeOf")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.AttributeOf.Get")
    @ApiOperation(value = "Returns a list of concepts that this is an attribute of")
    public Response getAttributeOf(@Context SecurityContext sc,
                                   @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get attribute of concepts");

        List<ConceptSummary> attributes = new ConceptLogic().getAttributeOf(id);

        return Response
            .ok()
            .entity(attributes)
            .build();
    }



    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Attribute")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attribute.Post")
    @ApiOperation(value = "Add an attribute")
    public Response addAttribute(@Context SecurityContext sc,
                                 @ApiParam(value = "Concept Id") @QueryParam("conceptId") Long conceptId,
                                 @ApiParam(value = "Attribute Id") @QueryParam("attributeId") Long attributeId) throws Exception {
        LOG.debug("Add attribiute");

        Long result = new ConceptLogic().addAttribute(conceptId, attributeId);

        return Response
            .ok()
            .entity(result)
            .build();
    }


    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Relationship")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Relationship.Post")
    @ApiOperation(value = "Add a relationship")
    public Response addRelationship(@Context SecurityContext sc,
                                    @ApiParam(value = "Source Id") @QueryParam("sourceId") Long sourceId,
                                    @ApiParam(value = "Target Id") @QueryParam("targetId") Long targetId,
                                    @ApiParam(value = "Relationship Id") @QueryParam("relationshipId") Long relationshipId) throws Exception {
        LOG.debug("Add relationship");

        Long result = new ConceptLogic().addRelationship(sourceId, targetId, relationshipId);

        return Response
            .ok()
            .entity(result)
            .build();
    }
    */
}