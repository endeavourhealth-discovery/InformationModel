package org.endeavourhealth.im.api.publicendpoints;

import org.endeavourhealth.common.utility.MetricsHelper;
import org.endeavourhealth.common.utility.MetricsTimer;
import org.endeavourhealth.im.dal.CommonJDBCDAL;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.*;
import java.io.*;
import java.sql.SQLException;

@Path("/")
public class PublicEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(PublicEndpoint.class);

    // Get dbid to scheme/code map
    @GET
    @Path("/DbidMap")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.TEXT_PLAIN)
    public Response dbidSchemeCodeMap(@Context SecurityContext sc,
                                      @QueryParam("start") int start,
                                      @QueryParam("end") Integer end,
                                      @QueryParam("draftOnly") Boolean draftOnly) throws Exception {

        try (MetricsTimer t = MetricsHelper.recordTime("Client.isSchemeCodeMemberOfValueSet")) {
            LOG.debug("isSchemeCodeMemberOfValueSet");

            Boolean finalDraftOnly = (draftOnly == null || draftOnly);

            StreamingOutput stream = new StreamingOutput() {
                @Override
                public void write(OutputStream outputStream) throws IOException, WebApplicationException {

                    try {
                        Writer writer = new BufferedWriter(new OutputStreamWriter(outputStream));
                        new CommonJDBCDAL().getDbidSchemeCodeMaps(start, end, finalDraftOnly, writer);
                    } catch (SQLException e) {
                        throw new WebApplicationException("Error fetching map", e);
                    }
                }
            };

            return Response
                .ok()
                .entity(stream)
                .build();
        }
    }
}
