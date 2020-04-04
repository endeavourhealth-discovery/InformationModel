package org.endeavourhealth.im.api.publicendpoints;

import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.endeavourhealth.im.dal.ViewerJDBCDAL;
import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.RelatedConcept;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("/Viewer")
public class ViewerEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ViewerEndpoint.class);

    @GET
    @Path("/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getConcept(@Context SecurityContext sc,
                               @PathParam("id") String id) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Viewer.getConcept")) {
            LOG.debug("getConcept");

            Concept result = new ViewerJDBCDAL().getConcept(id);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/{id}/Targets")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getTargets(@Context SecurityContext sc,
                                @PathParam("id") String id,
                                @QueryParam("relationship") List<String> relationships) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Viewer.getTargets")) {
            LOG.debug("getTargets");

            List<RelatedConcept> result = new ViewerJDBCDAL().getTargets(id, relationships);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }

    @GET
    @Path("/{id}/Sources")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getSources(@Context SecurityContext sc,
                               @PathParam("id") String id,
                               @QueryParam("relationship") List<String> relationships) throws Exception {
        try (MetricsTimer t = MetricsHelper.recordTime("Viewer.getSources")) {
            LOG.debug("getSources");

            List<RelatedConcept> result = new ViewerJDBCDAL().getSources(id, relationships);

            return Response
                .ok()
                .entity(result)
                .build();
        }
    }
}
