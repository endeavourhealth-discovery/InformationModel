package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.logic.ConceptLogic;
import org.endeavourhealth.im.common.models.Concept;
import org.endeavourhealth.im.common.models.ConceptSummary;
import org.endeavourhealth.im.common.models.RelatedConcept;
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
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Get")
    @ApiOperation(value = "Returns Concept by id")
    public Response get(@Context SecurityContext sc,
                        @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get concept");

        Concept concept = new ConceptLogic().get(id);

        return Response
                .ok()
                .entity(concept)
                .build();
    }

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

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Post")
    @ApiOperation(value = "Saves a concept")
    public Response save(@Context SecurityContext sc,
                                 @ApiParam(value = "Concept to save") Concept concept
    ) throws Exception {
        LOG.debug("Save concept");

        Long id = new ConceptLogic().save(concept);

        return Response
                .ok()
                .entity(id)
                .build();
    }


    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Search")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Search")
    @ApiOperation(value = "Returns Concept summaries based on search criteria")
    public Response search(@Context SecurityContext sc,
                                 @ApiParam(value = "Search criteria") @QueryParam("criteria") String criteria
    ) throws Exception {
        LOG.debug("Get concept summaries");

        List<ConceptSummary> concepts = new ConceptLogic().search(criteria);

        return Response
                .ok()
                .entity(concepts)
                .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/RelatedTargets")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.RelatedTargets")
    @ApiOperation(value = "Returns related target concepts by id")
    public Response getRelatedTargets(@Context SecurityContext sc,
                                 @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get related target concepts");

        List<RelatedConcept> concepts = new ConceptLogic().getRelatedTargets(id);

        return Response
            .ok()
            .entity(concepts)
            .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/RelatedSources")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.RelatedSources")
    @ApiOperation(value = "Returns related source concepts by id")
    public Response getRelatedSources(@Context SecurityContext sc,
                               @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get related source concepts");

        List<RelatedConcept> concepts = new ConceptLogic().getRelatedSources(id);

        return Response
            .ok()
            .entity(concepts)
            .build();
    }


    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Attribute")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attribute")
    @ApiOperation(value = "Returns a list of attributes of a concept")
    public Response getAttributes(@Context SecurityContext sc,
                                      @ApiParam(value = "Concept Id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get concept attributes");

        List<ConceptSummary> attributes = new ConceptLogic().getAttributes(id);

        return Response
            .ok()
            .entity(attributes)
            .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/AttributeOf")
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.AttributeOf")
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
}