package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.*;
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

@SwaggerDefinition(
    info = @Info(
        description = "Query and manipulate the Information Model",
        version = "V1.0.0",
        title = "The Information Model API",
        termsOfService = "https://discoverdataservice.net/terms.html",
        contact = @Contact(
            name = "Support",
            email = "Support@discoverydataservice.net",
            url = "https://discoverydataservice.net"
        ),
        license = @License(
            name = "Apache 2.0",
            url = "http://www.apache.org/licenses/LICENSE-2.0"
        )
    ),
    consumes = {"application/json"},
    produces = {"application/json"},
    schemes = {SwaggerDefinition.Scheme.HTTPS},
    externalDocs = @ExternalDocs(value = "Information model", url = "https://discoverydataservice.net/informationmodel.html")
)

@Path("Concept")
@Metrics(registry = "ConceptMetricRegistry")
@Api(value = "Concept", description = "API for all calls relating to Concepts")
public class ConceptEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptEndpoint.class);

    /******************** CONCEPTS ********************/

    @GET
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.GET")
    @ApiOperation(value = "Returns concept by ID", response = Concept.class)
    public Response getById(@Context SecurityContext sc,
                            @ApiParam(value = "Concept ID", required = true) @PathParam("id") Long id) throws Exception {
        LOG.debug("Get concept by ID");

        Concept result = new ConceptLogic().get(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.POST")
    @ApiOperation(value = "Saves a concept to the database and returns the result",
        response = Concept.class,
        notes = "Where new database entries are created, the IDs will be populated in the returned bundle")
    public Response saveConcept(@Context SecurityContext sc,
                                @ApiParam(value = "Concept to save", required = true) Concept concept) throws Exception {
        LOG.debug("Save concept");

        new ConceptLogic().saveConcept(concept);

        return Response
            .ok()
            .entity(concept)
            .build();
    }

    @DELETE
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.DELETE")
    @ApiOperation(value = "Deletes a concept from the database")
    public Response deleteConcept(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept id", required = true) @PathParam("id") Long id) throws Exception {
        LOG.debug("Delete concept");

        new ConceptLogic().deleteConcept(id);

        return Response
            .ok()
            .build();
    }


    @GET
    @Path("/{id}/Synonyms")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Synonyms.GET")
    @ApiOperation(value = "Returns synonyms for the given concept", response = Synonym.class, responseContainer = "List")
    public Response getAttributes(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept id", required = true) @PathParam("id") Long id) throws Exception {
        LOG.debug("Get synonyms by ID");

        List<Synonym> result = new ConceptLogic().getSynonyms(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/{id}/Subtypes")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Subtypes.GET")
    @ApiOperation(value = "Returns subtypes of the given concept", response = Concept.class)
    public Response getConceptSubtypes(@Context SecurityContext sc,
                                       @ApiParam(value = "Concept ID", required = true) @PathParam("id") Long id,
                                       @ApiParam(value = "All", required = false) @QueryParam("all") Boolean all) throws Exception {
        LOG.debug("Get concept by ID");

        List<ConceptSummary> result = new ConceptLogic().getSubtypes(id, all);

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
    @ApiOperation(value = "Returns concept by context", response = Concept.class)
    public Response getByContext(@Context SecurityContext sc,
                                 @ApiParam(value = "Concept context", required = true) @QueryParam("context") String context,
                                 @ApiParam(value = "Create missing") @QueryParam("createMissing") Boolean createMissing) throws Exception {
        LOG.debug("Get concept by ID");

        Concept result = new ConceptLogic().get(context, createMissing);

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
    @ApiOperation(value = "Returns most recently used concepts", response = SearchResult.class)
    public Response getMRU(@Context SecurityContext sc,
                           @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated) throws Exception {
        LOG.debug("Get most recently used concepts");

        SearchResult result = new ConceptLogic().getMRU(includeDeprecated);

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
    @ApiOperation(value = "Returns list of concepts matching the given term", response = SearchResult.class)
    public Response search(@Context SecurityContext sc,
                           @ApiParam(value = "Term", required = true) @QueryParam("searchTerm") String term,
                           @ApiParam(value = "Page") @QueryParam("page") Integer page,
                           @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated,
                           @ApiParam(value = "Scheme filter") @QueryParam("scheme") List<Long> schemes,
                           @ApiParam(value = "Optional concept restriction") @QueryParam("relatedConcept") Long relatedConcept,
                           @ApiParam(value = "Optional relationship expression ID") @QueryParam("expression") Byte expression) throws Exception {
        LOG.debug("Search by term");

        SearchResult result = new ConceptLogic().search(term, page, includeDeprecated, schemes, relatedConcept, ValueExpression.byValue(expression));

        return Response
            .ok()
            .entity(result)
            .build();
    }

/*
    @GET
    @Path("/Related")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Related.GET")
    @ApiOperation(value = "Returns list of related concepts for the given concept", response = RelatedConcept.class, responseContainer = "List")
    public Response getRelated(@Context SecurityContext sc,
                               @ApiParam(value = "Concept id", required = true) @QueryParam("id") Long id,
                               @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated) throws Exception {
        LOG.debug("Get related by ID");

        List<RelatedConcept> result = new ConceptLogic().getRelated(id, includeDeprecated);

        return Response
            .ok()
            .entity(result)
            .build();
    }
*/

    /******************** ATTRIBUTES ********************/

    @GET
    @Path("/{id}/Attribute")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attributes.GET")
    @ApiOperation(value = "Returns attributes for the given concept", response = Attribute.class, responseContainer = "List")
    public Response getAttributes(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept id", required = true) @PathParam("id") Long id,
                                  @ApiParam(value = "Include deprecated") @QueryParam("includeDeprecated") Boolean includeDeprecated) throws Exception {
        LOG.debug("Get attributes by ID");

        List<Attribute> result = new ConceptLogic().getAttributes(id, includeDeprecated);

        return Response
            .ok()
            .entity(result)
            .build();
    }


    @POST
    @Path("/{id}/Attribute")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attribute.POST")
    @ApiOperation(value = "Saves an attribute to the database and returns the result",
        response = Attribute.class,
        notes = "Where new database entries are created, the IDs will be populated in the returned attribute")
    public Response saveAttribute(@Context SecurityContext sc,
                                @ApiParam(value = "Concept the attribute relates to", required = true) @PathParam("id") Long conceptId,
                                @ApiParam(value = "Attribute to save", required = true) Attribute attribute) throws Exception {
        LOG.debug("Save attribute");

        new ConceptLogic().saveAttribute(conceptId, attribute);

        return Response
            .ok()
            .entity(attribute)
            .build();
    }

    @DELETE
    @Path("/Attribute/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attribute.DELETE")
    @ApiOperation(value = "Deletes an attribute from the database")
    public Response deleteAttribute(@Context SecurityContext sc,
                                    @ApiParam(value = "Attribute id", required = true) @PathParam("id") Long id) throws Exception {
        LOG.debug("Delete attribute");

        new ConceptLogic().deleteAttribute(id);

        return Response
            .ok()
            .build();
    }
}