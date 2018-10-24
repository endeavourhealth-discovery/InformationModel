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

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.GET")
    @ApiOperation(value = "Returns concept by ID", response = Concept.class)
    public Response getById(@Context SecurityContext sc,
                            @ApiParam(value = "Concept ID", required = true) @QueryParam("id") Long id) throws Exception {
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
    @ApiOperation(value = "Returns concept by context", response = Concept.class)
    public Response getByContext(@Context SecurityContext sc,
                                 @ApiParam(value = "Concept context", required = true) @QueryParam("context") String context,
                                 @ApiParam(value = "Concept value", required = true) @QueryParam("value") String value) throws Exception {
        LOG.debug("Get concept by ID");

        Concept result = new ConceptLogic().get(context, value);

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
                           @ApiParam(value = "Optional superclass restriction") @QueryParam("superclass") Long superclass) throws Exception {
        LOG.debug("Search by term");

        SearchResult result = new ConceptLogic().search(term, page, includeDeprecated, superclass);

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

    @GET
    @Path("/Attributes")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ConceptEndpoint.Attributes.GET")
    @ApiOperation(value = "Returns attributes for the given concept", response = Attribute.class, responseContainer = "List")
    public Response getAttributes(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept id", required = true) @QueryParam("id") Long id,
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
    @ApiOperation(value = "Returns synonyms for the given concept", response = Synonym.class, responseContainer = "List")
    public Response getAttributes(@Context SecurityContext sc,
                                  @ApiParam(value = "Concept id", required = true) @QueryParam("id") Long id) throws Exception {
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
    @ApiOperation(value = "Saves a concept & associated edits (bundle) to the database and returns the result",
        response = Bundle.class,
        notes = "Where new database entries are created, the IDs will be populated in the returned bundle")
    public Response saveConcept(@Context SecurityContext sc,
                                @ApiParam(value = "Concept bundle to save", required = true) Bundle bundle) throws Exception {
        LOG.debug("Save concept");

        new ConceptLogic().saveConceptBundle(bundle);

        return Response
            .ok()
            .entity(bundle)
            .build();
    }

}