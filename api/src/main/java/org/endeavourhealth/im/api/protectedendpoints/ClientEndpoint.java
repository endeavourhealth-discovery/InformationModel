package org.endeavourhealth.im.api.protectedendpoints;

import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.endeavourhealth.im.dal.IMClientJDBCDAL;
import org.endeavourhealth.im.dal.ValueSetJDBCDAL;
import org.endeavourhealth.im.logic.MappingLogic;
import org.endeavourhealth.im.models.mapping.MapRequest;
import org.endeavourhealth.im.models.mapping.MapResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;

@Path("/")
public class ClientEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ClientEndpoint.class);

    // V1 / Code APIs
    @GET
    @Path("/Concept/Id")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response getConceptIdForSchemeCode(@Context SecurityContext sc,
                                                   @QueryParam("scheme") String scheme,
                                                   @QueryParam("code") String code) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getConceptIdForSchemeCode")) {
            LOG.debug("getConceptIdForSchemeCode");

            String result = new IMClientJDBCDAL().getConceptIdForSchemeCode(scheme, code);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Concept/Core/Code")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response getMappedCoreCodeForSchemeCode(@Context SecurityContext sc,
                                                   @QueryParam("scheme") String scheme,
                                                   @QueryParam("code") String code,
                                                   @QueryParam("snomedOnly") Boolean snomedOnly) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getMappedCoreCodeForSchemeCode")) {
            LOG.debug("getMappedCoreCodeForSchemeCode");

            if (snomedOnly == null)
                snomedOnly = false;

            String result = new IMClientJDBCDAL().getMappedCoreCodeForSchemeCode(scheme, code, snomedOnly);

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
    public Response getCodeForTypeTerm(@Context SecurityContext sc,
                                       @QueryParam("scheme") String scheme,
                                       @QueryParam("context") String context,
                                       @QueryParam("term") String term,
                                       @QueryParam("autoCreate") boolean autoCreate) throws Exception {
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
    public Response getConceptDbidForSchemeCode(@Context SecurityContext sc,
                                                @QueryParam("context") String context,
                                                @QueryParam("scheme") String scheme,
                                                @QueryParam("code") String code,
                                                @QueryParam("autoCreate") boolean autoCreate,
                                                @QueryParam("term") String term) throws Exception {
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
    public Response getMappedCoreConceptDbidForSchemeCode(@Context SecurityContext sc,
                                                          @QueryParam("scheme") String scheme,
                                                          @QueryParam("code") String code) throws Exception {
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
    public Response getCodeForConceptDbid(@Context SecurityContext sc,
                                          @QueryParam("dbid") Integer dbid) throws Exception {
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
    public Response getConceptDbidForTypeTerm(@Context SecurityContext sc,
                                              @QueryParam("type") String type,
                                              @QueryParam("term") String term,
                                              @QueryParam("autoCreate") boolean autoCreate) throws Exception {
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
    public Response getMappedCoreConceptDbidForTypeTerm(@Context SecurityContext sc,
                                                        @QueryParam("type") String type,
                                                        @QueryParam("term") String term) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getMappedCoreConceptDbidForTypeTerm")) {
            LOG.debug("getMappedCoreConceptDbidForTypeTerm");

            Integer result = new IMClientJDBCDAL().getMappedCoreConceptDbidForTypeTerm(type, term);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    // Mapping API
    @POST
    @Path("/Mapping")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMapping(@Context SecurityContext sc,
                               MapRequest request) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.getMapping")) {
            LOG.debug("getMapping");

            MapResponse result = new MappingLogic().getMapping(request);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    // Valueset API
    @GET
    @Path("/ValueSet")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response isSchemeCodeMemberOfValueSet(@Context SecurityContext sc,
                                                 @QueryParam("scheme") String scheme,
                                                 @QueryParam("code") String code,
                                                 @QueryParam("valueset") String valueSet) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Client.isSchemeCodeMemberOfValueSet")) {
            LOG.debug("isSchemeCodeMemberOfValueSet");

            Boolean result = new ValueSetJDBCDAL().isSchemeCodeMemberOfValueSet(scheme, code, valueSet);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

}
