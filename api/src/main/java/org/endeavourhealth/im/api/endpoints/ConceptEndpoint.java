package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.logic.ConceptLogic;
import org.endeavourhealth.im.models.*;
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
@Api(value = "Concept", description = "API for all calls relating to Concepts")
public class ConceptEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptEndpoint.class);

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.GET")
    @ApiOperation(value = "Returns concept by ID")
    public Response getById(@Context SecurityContext sc,
                            @ApiParam(value = "Concept ID") @QueryParam("id") Long id) throws Exception {
        LOG.debug("Get concept by ID");

        Concept result = new ConceptLogic().get(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Context")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Context.GET")
    @ApiOperation(value = "Returns concept by context")
    public Response getByContext(@Context SecurityContext sc,
                                 @ApiParam(value = "Concept context") @QueryParam("context") String context) throws Exception {
        LOG.debug("Get concept by ID");

        Concept result = new ConceptLogic().get(context);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/MRU")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.MRU.GET")
    @ApiOperation(value = "Returns most recently used concepts")
    public Response getMRU(@Context SecurityContext sc,
    @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated) throws Exception {
        LOG.debug("Get most recently used concepts");

        List<ConceptSummary> result = new ConceptLogic().getMRU(includeDeprecated);

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
    @ApiOperation(value = "Returns list of concepts matching the given term")
    public Response search(@Context SecurityContext sc,
                           @ApiParam(value = "Term") @QueryParam("searchTerm") String term,
                           @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated,
                           @ApiParam(value = "Optional superclass restriction") @QueryParam("superclass") Long superclass) throws Exception {
        LOG.debug("Search by term");

        List<ConceptSummary> result = new ConceptLogic().search(term, includeDeprecated, superclass);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Related")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Related.GET")
    @ApiOperation(value = "Returns list of related concepts for the given concept")
    public Response getRelated(@Context SecurityContext sc,
                               @ApiParam(value = "Concept id") @QueryParam("id") Long id,
                               @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated) throws Exception {
        LOG.debug("Get related by ID");

        List<RelatedConcept> result = new ConceptLogic().getRelated(id, includeDeprecated);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Attributes")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attributes.GET")
    @ApiOperation(value = "Returns attributes for the given concept")
    public Response getAttributes(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept id") @QueryParam("id") Long id,
                                  @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated) throws Exception {
        LOG.debug("Get attributes by ID");

        List<Attribute> result = new ConceptLogic().getAttributes(id, includeDeprecated);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Synonyms")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Synonyms.GET")
    @ApiOperation(value = "Returns synonyms for the given concept")
    public Response getAttributes(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept id") @QueryParam("id") Long id) throws Exception {
        LOG.debug("Get synonyms by ID");

        List<Synonym> result = new ConceptLogic().getSynonyms(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attributes.POST")
    @ApiOperation(value = "Saves a concept & associated edits (bundle) to the database and returns the result")
    public Response saveConcept(@Context SecurityContext sc,
                         @ApiParam(value = "Concept bundle to save") Bundle bundle) throws Exception {
        LOG.debug("Save concept");

        new ConceptLogic().saveConceptBundle(bundle);

        return Response
            .ok()
            .entity(bundle)
            .build();
    }

}