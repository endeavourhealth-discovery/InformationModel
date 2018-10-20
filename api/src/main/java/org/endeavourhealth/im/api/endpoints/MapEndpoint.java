package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.*;
import org.endeavourhealth.im.logic.MapLogic;
import org.endeavourhealth.im.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("Map")
@Metrics(registry = "MapMetricRegistry")
@Api(value = "Map", description = "API for all calls relating to Maps")
public class MapEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(MapEndpoint.class);

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.MapEndpoint.GET")
    @ApiOperation(value = "Returns concept by ID", response = Concept.class)
    public Response get(@Context SecurityContext sc,
                        @ApiParam(value = "Code", required = true) @QueryParam("code") String code,
                        @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") Long scheme) throws Exception {
        LOG.debug("Get concept by code map");

        Concept result = new MapLogic().get(code, scheme);

        return Response
            .ok()
            .entity(result)
            .build();
    }
}