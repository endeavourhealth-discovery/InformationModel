package org.endeavourhealth.im.api.endpoints;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.endeavourhealth.im.dal.CommonJDBCDAL;
import org.endeavourhealth.im.models.KVP;
import org.endeavourhealth.im.models.Related;
import org.endeavourhealth.im.models.SearchResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("/Common")
@Api(tags = {"Common"})
public class CommonEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(CommonEndpoint.class);

    @GET
    @Path("/CodeScheme")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @ApiOperation(value = "Get list of known code schemes", response = Integer.class)
    public Response getCodeSchemes(@Context SecurityContext sc) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Common.getCodeSchemes")) {
            LOG.debug("getCodeScheme");

            List<KVP> result = new CommonJDBCDAL().getCodeSchemes();

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Concept/Search")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @ApiOperation(value = "Search concepts with option scheme restriction", response = Integer.class)
    public Response search(@Context SecurityContext sc,
                           @ApiParam(value = "Term", required = true) @QueryParam("term") String term,
                           @ApiParam(value = "Schemes") @QueryParam("scheme") List<Integer> schemes,
                           @ApiParam(value = "Page") @QueryParam("page") Integer page,
                           @ApiParam(value = "Page size") @QueryParam("pageSize") Integer pageSize) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Common.search")) {
            LOG.debug("Search");

            SearchResult result = new CommonJDBCDAL().search(term, schemes, page, pageSize);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Concept/{id}/Related")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @ApiOperation(value = "Get concepts this one relates to", response = Integer.class)
    public Response getRelated(@Context SecurityContext sc,
                           @ApiParam(value = "Dbid") @PathParam("id") String id,
                           @ApiParam(value = "Relationships") @QueryParam("relationship") List<String> relationships) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Common.getRelated")) {
            LOG.debug("Search");

            List<Related> result = new CommonJDBCDAL().getRelated(id, relationships);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/Concept/{id}/Related/Reverse")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @ApiOperation(value = "Get concepts related to this one", response = Integer.class)
    public Response getReverseRelated(@Context SecurityContext sc,
                               @ApiParam(value = "Dbid") @PathParam("id") String id,
                               @ApiParam(value = "Relationships") @QueryParam("relationship") List<String> relationships) throws Exception {
        try(MetricsTimer t = MetricsHelper.recordTime("Common.getReverseRelated")) {
            LOG.debug("Search");

            List<Related> result = new CommonJDBCDAL().getReverseRelated(id, relationships);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }
}
