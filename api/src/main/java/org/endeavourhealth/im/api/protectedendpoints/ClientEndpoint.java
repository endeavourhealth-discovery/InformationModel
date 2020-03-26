package org.endeavourhealth.im.api.protectedendpoints;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.endeavourhealth.im.dal.IMClientJDBCDAL;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("/")
@Api(tags = {"Client"})
public class ClientEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ClientEndpoint.class);

    // V2 / Code APIs
    @GET
    @Path("/Concept/Core/Code")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @ApiOperation(value = "Get core code for given scheme and code", response = Integer.class)
    public Response getMappedCoreCodeForSchemeCode(@Context SecurityContext sc,
                                                          @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") String scheme,
                                                          @ApiParam(value = "Code", required = true) @QueryParam("code") String code) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getMappedCoreCodeForSchemeCode")) {
            LOG.debug("getMappedCoreCodeForSchemeCode");

            String result = new IMClientJDBCDAL().getMappedCoreCodeForSchemeCode(scheme, code);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Term/Code")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @ApiOperation(value = "Get code for given scheme, context and term", response = Integer.class)
    public Response getCodeForTypeTerm(@Context SecurityContext sc,
                                              @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") String scheme,
                                              @ApiParam(value = "Context", required = true) @QueryParam("context") String context,
                                              @ApiParam(value = "Term", required = true) @QueryParam("term") String term,
                                              @ApiParam(value = "AutoCreate", required = false) @QueryParam("autoCreate") boolean autoCreate) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getCodeForTypeTerm")) {
            LOG.debug("getCodeForTypeTerm");

            String result = new IMClientJDBCDAL().getCodeForTypeTerm(scheme, context, term, autoCreate);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    // V2 / Concept DBID APIs
    @GET
    @Path("/Concept")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @ApiOperation(value = "Get concept dbid for given scheme and code", response = Integer.class)
    public Response getConceptDbidForSchemeCode(@Context SecurityContext sc,
                                                @ApiParam(value = "Context", required = false) @QueryParam("context") String context,
                                                @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") String scheme,
                                                @ApiParam(value = "Code", required = true) @QueryParam("code") String code,
                                                @ApiParam(value = "AutoCreate", required = false) @QueryParam("autoCreate") boolean autoCreate,
                                                @ApiParam(value = "Term", required = false) @QueryParam("term") String term) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getConceptDbidForSchemeCode")) {
            LOG.debug("getConceptDbidForSchemeCode");

            Integer result = new IMClientJDBCDAL().getConceptDbidForSchemeCode(context, scheme, code, autoCreate, term);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Concept/Core")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @ApiOperation(value = "Get core concept dbid for given scheme and code", response = Integer.class)
    public Response getMappedCoreConceptDbidForSchemeCode(@Context SecurityContext sc,
                                                          @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") String scheme,
                                                          @ApiParam(value = "Code", required = true) @QueryParam("code") String code) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getMappedCoreConceptDbidForSchemeCode")) {
            LOG.debug("getMappedCoreConceptDbidForSchemeCode");

            Integer result = new IMClientJDBCDAL().getMappedCoreConceptDbidForSchemeCode(scheme, code);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Concept/Code")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @ApiOperation(value = "Get code for given concept dbid", response = Integer.class)
    public Response getCodeForConceptDbid(@Context SecurityContext sc,
                                          @ApiParam(value = "Concept DBID", required = true) @QueryParam("dbid") Integer dbid) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getCodeForConceptDbid")) {
            LOG.debug("getCodeForConceptDbid");

            String result = new IMClientJDBCDAL().getCodeForConceptDbid(dbid);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Term")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @ApiOperation(value = "Get concept dbid for given type and term", response = Integer.class)
    public Response getConceptDbidForTypeTerm(@Context SecurityContext sc,
                                              @ApiParam(value = "Term type", required = true) @QueryParam("type") String type,
                                              @ApiParam(value = "Term", required = true) @QueryParam("term") String term,
                                              @ApiParam(value = "AutoCreate", required = false) @QueryParam("autoCreate") boolean autoCreate) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getConceptDbidForTypeTerm")) {
            LOG.debug("getConceptDbidForTypeTerm");

            Integer result = new IMClientJDBCDAL().getConceptDbidForTypeTerm(type, term, autoCreate);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Term/Core")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @ApiOperation(value = "Get (mapped) core concept dbid for given type and term", response = Integer.class)
    public Response getMappedCoreConceptDbidForTypeTerm(@Context SecurityContext sc,
                                                        @ApiParam(value = "Term type", required = true) @QueryParam("type") String type,
                                                        @ApiParam(value = "Term", required = true) @QueryParam("term") String term) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getMappedCoreConceptDbidForTypeTerm")) {
            LOG.debug("getMappedCoreConceptDbidForTypeTerm");

            Integer result = new IMClientJDBCDAL().getMappedCoreConceptDbidForTypeTerm(type, term);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }
}
