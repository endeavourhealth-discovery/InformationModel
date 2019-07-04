package org.endeavourhealth.im.api.protectedendpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.dal.IMClientJDBCDAL;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("/")
@Metrics(registry = "ClientMetricRegistry")
@Api(tags = {"Client"})
public class ClientEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ClientEndpoint.class);

    @GET
    @Path("/Concept")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ClientEndpoint.SchemeCode.GET")
    @ApiOperation(value = "Get concept id for given scheme and code", response = Integer.class)
    public Response getConceptIdForSchemeCode(@Context SecurityContext sc,
                                              @ApiParam(value = "Context", required = false) @QueryParam("context") String context,
                                              @ApiParam(value = "Scheme", required = true) @QueryParam("scheme") String scheme,
                                              @ApiParam(value = "Code", required = true) @QueryParam("code") String code,
                                              @ApiParam(value = "AutoCreate", required = false) @QueryParam("autoCreate") Boolean autoCreate,
                                              @ApiParam(value = "Term", required = false) @QueryParam("term") String term) throws Exception {
        LOG.debug("getConceptIdForSchemeCode");

        Integer result = new IMClientJDBCDAL().getConceptIdForSchemeCode(context, scheme, code, autoCreate, term);

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

        Integer result = new IMClientJDBCDAL().getMappedCoreConceptIdForSchemeCode(scheme, code);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Concept/Code")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ClientEndpoint.ConceptCode.GET")
    @ApiOperation(value = "Get code for given concept id", response = Integer.class)
    public Response getCodeForConceptId(@Context SecurityContext sc,
                                                        @ApiParam(value = "Concept DBID", required = true) @QueryParam("dbid") Integer dbid) throws Exception {
        LOG.debug("getCodeForConceptId");

        String result = new IMClientJDBCDAL().getCodeForConceptId(dbid);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Term")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ClientEndpoint.Term.GET")
    @ApiOperation(value = "Get concept id for given type and term", response = Integer.class)
    public Response getConceptIdForTypeTerm(@Context SecurityContext sc,
                                        @ApiParam(value = "Term type", required = true) @QueryParam("type") String type,
                                            @ApiParam(value = "Term", required = true) @QueryParam("term") String term,
                                            @ApiParam(value = "AutoCreate", required = false) @QueryParam("autoCreate") Boolean autoCreate) throws Exception {
        LOG.debug("getConceptIdForTypeTerm");

        Integer result = new IMClientJDBCDAL().getConceptIdForTypeTerm(type, term, autoCreate);

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/Term/Core")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    @Timed(absolute = true, name = "InformationModel.ClientEndpoint.TermCore.GET")
    @ApiOperation(value = "Get (mapped) core concept id for given type and term", response = Integer.class)
    public Response getMappedCoreConceptIdForTypeTerm(@Context SecurityContext sc,
                                            @ApiParam(value = "Term type", required = true) @QueryParam("type") String type,
                                            @ApiParam(value = "Term", required = true) @QueryParam("term") String term) throws Exception {
        LOG.debug("getMappedCoreConceptIdForTypeTerm");

        Integer result = new IMClientJDBCDAL().getMappedCoreConceptIdForTypeTerm(type, term);

        return Response
            .ok()
            .entity(result)
            .build();
    }
}
