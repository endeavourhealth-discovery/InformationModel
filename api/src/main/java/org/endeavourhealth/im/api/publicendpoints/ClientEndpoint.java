package org.endeavourhealth.im.api.publicendpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.endpoints.InformationModelEndpoint;
import org.endeavourhealth.im.dal.InformationModelJDBCDAL;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("Client")
@Metrics(registry = "ClientMetricRegistry")
@Api(tags = {"Client"})
public class ClientEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(InformationModelEndpoint.class);

    @GET
    @Path("/Concept")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ClientEndpoint.SchemeCode.GET")
    @ApiOperation(value = "Get concept id for given scheme and code", response = Integer.class)
    public Response getConceptIdForSchemeCode(@Context SecurityContext sc,
                                              @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") String scheme,
                                              @ApiParam(value = "Code", required = true) @QueryParam("code") String code) throws Exception {
        LOG.debug("getConceptIdForSchemeCode");

        Integer result = new InformationModelJDBCDAL().getConceptIdForSchemeCode(scheme, code);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Concept/Core")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ClientEndpoint.SchemeCodeCore.GET")
    @ApiOperation(value = "Get core concept id for given scheme and code", response = Integer.class)
    public Response getMappedCoreConceptIdForSchemeCode(@Context SecurityContext sc,
                                              @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") String scheme,
                                              @ApiParam(value = "Code", required = true) @QueryParam("code") String code) throws Exception {
        LOG.debug("getMappedCoreConceptIdForSchemeCode");

        Integer result = new InformationModelJDBCDAL().getMappedCoreConceptIdForSchemeCode(scheme, code);

        return Response
            .ok()
            .entity(result)
            .build();
    }

}
