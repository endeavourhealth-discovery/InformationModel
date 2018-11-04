package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.logic.ConceptLogic;
import org.endeavourhealth.im.logic.TermLogic;
import org.endeavourhealth.im.logic.ViewLogic;
import org.endeavourhealth.im.models.*;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.io.InputStream;
import java.util.List;

@Path("View")
@Metrics(registry = "ViewMetricRegistry")
@Api(description = "API for all calls relating to Viewss")
public class ViewEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ViewEndpoint.class);

    @GET
    @Path("List")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.List.Get")
    @ApiOperation(value = "Returns list of defined views")
    public Response getList(@Context SecurityContext sc,
                        @ApiParam(value = "Parent") @QueryParam("parent") Long parent
    ) throws Exception {
        LOG.debug("Get view list");

        List<View> result = new ViewLogic().list(parent);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.Get")
    @ApiOperation(value = "Returns a view")
    public Response get(@Context SecurityContext sc,
                        @ApiParam(value = "id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get view");

        View result = new ViewLogic().get(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("Concepts")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.Concepts.Get")
    @ApiOperation(value = "Returns list of concepts for a given view")
    public Response getChildren(@Context SecurityContext sc,
                        @ApiParam(value = "id") @QueryParam("id") Long id
    ) throws Exception {
        LOG.debug("Get view concepts");

        List<ConceptSummary> result = new ViewLogic().getConcepts(id);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.POST")
    @ApiOperation(value = "Saves a view to the database and returns the result",
        response = View.class,
        notes = "Where new database entries are created, the ID will be populated in the returned view")
    public Response save(@Context SecurityContext sc,
                         @ApiParam(value = "View to save", required = true) View view) throws Exception {
        LOG.debug("Save concept");

        View result = new ViewLogic().save(view);

        return Response
            .ok()
            .entity(result)
            .build();
    }
}