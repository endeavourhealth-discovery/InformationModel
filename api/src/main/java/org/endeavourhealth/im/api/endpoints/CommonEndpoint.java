package org.endeavourhealth.im.api.endpoints;

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
public class CommonEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(CommonEndpoint.class);

    @GET
    @Path("/CodeScheme")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
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
    public Response search(@Context SecurityContext sc,
                           @QueryParam("term") String term,
                           @QueryParam("scheme") List<Integer> schemes,
                           @QueryParam("page") Integer page,
                           @QueryParam("pageSize") Integer pageSize) throws Exception {
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
    public Response getRelated(@Context SecurityContext sc,
                           @PathParam("id") String id,
                           @QueryParam("relationship") List<String> relationships) throws Exception {
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
    public Response getReverseRelated(@Context SecurityContext sc,
                               @PathParam("id") String id,
                               @QueryParam("relationship") List<String> relationships) throws Exception {
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
