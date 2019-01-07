package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.dal.DALException;
import org.endeavourhealth.im.dal.ViewJDBCDAL;
import org.endeavourhealth.im.logic.ViewLogic;
import org.endeavourhealth.im.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("View")
@Metrics(registry = "ViewMetricRegistry")
@Api(description = "API for all calls relating to Viewss")
public class ViewEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ViewEndpoint.class);

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.GET")
    @ApiOperation(value = "Returns list of defined views")
    public Response getList(@Context SecurityContext sc) throws DALException {
        LOG.debug("Get views");

        List<View> result = new ViewJDBCDAL().list();

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/{viewId}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.{viewId}.GET")
    @ApiOperation(value = "Returns a view")
    public Response getView(@Context SecurityContext sc,
                            @ApiParam(value = "View id") @PathParam("viewId") Long viewId
    ) throws DALException {
        LOG.debug("Get view");

        View result = new ViewJDBCDAL().get(viewId);

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
        response = ViewItem.class,
        notes = "Where new database entries are created, the ID will be populated in the returned view")
    public Response save(@Context SecurityContext sc,
                         @ApiParam(value = "View", required = true) View view) throws DALException {
        LOG.debug("Save view");

        View result = new ViewJDBCDAL().save(view);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @DELETE
    @Path("/{viewId}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.{viewId}.DELETE")
    @ApiOperation(value = "Deletes a view")
    public Response deleteView(@Context SecurityContext sc,
                               @ApiParam(value = "View id") @PathParam("viewId") Long viewId
    ) throws DALException {
        LOG.debug("Delete view");

        new ViewJDBCDAL().delete(viewId);

        return Response
            .ok()
            .build();
    }

    @GET
    @Path("/{viewId}/Children")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.{viewId}.Children.GET")
    @ApiOperation(value = "Returns a view")
    public Response getChildren(@Context SecurityContext sc,
                                @ApiParam(value = "View id") @PathParam("viewId") Long view,
                                @ApiParam(value = "Parent") @QueryParam("parentId") Long parent
    ) throws DALException {
        LOG.debug("Get view contents");

        List<ViewItem> result = new ViewLogic().getViewContents(view, parent);

        return Response
            .ok()
            .entity(result)
            .build();
    }


    @POST
    @Path("{viewId}/Item/{conceptId}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.{id}.Item.POST")
    @ApiOperation(value = "Saves a view to the database and returns the result",
        response = ViewItem.class,
        notes = "Where new database entries are created, the ID will be populated in the returned view")
    public Response addItem(@Context SecurityContext sc,
                            @ApiParam(value = "View to add to", required = true) @PathParam("viewId") Long viewId,
                            @ApiParam(value = "Concept id", required = true) @PathParam("conceptId") Long conceptId,
                            @ApiParam(value = "Add style", required = true) @QueryParam("addStyle") Integer addStyle,
                            @ApiParam(value = "Parent", required = false) @QueryParam("parentId") Long parentId,
                            @ApiParam(value = "Attribute ids", required = true) List<Long> attributeIds) throws DALException {
        LOG.debug("Add to view");

        new ViewJDBCDAL().addItem(viewId, ViewItemAddStyle.fromInt(addStyle), conceptId, attributeIds, parentId);

        return Response
            .ok()
            .build();
    }

    @DELETE
    @Path("ViewItem/{viewItemId}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.ViewEndpoint.{viewId}.DELETE")
    @ApiOperation(value = "Delete a view item")
    public Response deleteViewItem(@Context SecurityContext sc,
                                   @ApiParam(value = "View item id") @PathParam("viewItemId") Long viewItemId
    ) throws DALException {
        LOG.debug("Delete view item");

        new ViewJDBCDAL().deleteViewItem(viewItemId);

        return Response
            .ok()
            .build();
    }
}