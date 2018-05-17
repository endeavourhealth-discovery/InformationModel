package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.logic.MessageLogic;
import org.endeavourhealth.im.common.models.Message;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("/Message")
@Metrics(registry = "MessageMetricRegistry")
@Api(description = "API for all calls relating to Messages")
public class MessageEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(MessageEndpoint.class);

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.MessageEndpoint.Validate")
    @Path("/Validate")
    @ApiOperation(value = "Returns flag stating if message is valid or not")
    public Response validate(@Context SecurityContext sc,
                             @ApiParam(value = "Message to validate") Message message
    ) throws Exception {
        LOG.debug("Validate message called");

        Boolean isValid = new MessageLogic().isValidAndMapped(message);

        return Response
                .ok()
                .entity(isValid)
                .build();
    }
}