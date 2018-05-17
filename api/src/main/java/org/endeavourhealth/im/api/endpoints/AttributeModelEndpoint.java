package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.logic.AttributeModelLogic;
import org.endeavourhealth.im.common.models.AttributeModelSummary;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("AttributeModel")
@Metrics(registry = "AttributeModelMetricRegistry")
@Api(description = "API for all calls relating to Attribute Models")
public class AttributeModelEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(AttributeModelEndpoint.class);

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/Summaries")
    @Timed(absolute = true, name = "InformationModel.AttributeModelEndpoint.Get")
    @ApiOperation(value = "Retrieves (paged) Attribute model summary information")
    public Response getSummaries(@Context SecurityContext sc,
                        @ApiParam(value = "Page number") @QueryParam("page") Integer page
    ) throws Exception {
        LOG.debug("Get attribute model summaries");

        List<AttributeModelSummary> models = new AttributeModelLogic().getSummaries(page);

        return Response
                .ok()
                .entity(models)
                .build();
    }
}