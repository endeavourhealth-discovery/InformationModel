package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.logic.TermLogic;
import org.endeavourhealth.im.api.models.TermMapping;
import org.endeavourhealth.im.common.models.Term;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("Term")
@Metrics(registry = "TermMetricRegistry")
@Api(description = "API for all calls relating to Terms")
public class TermEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(TermEndpoint.class);

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.TermEndpoint.Get")
    @ApiOperation(value = "Returns Term by code in context")
    public Response getMappedTermForCodeInContext(@Context SecurityContext sc,
                                                  @ApiParam(value = "Organisation") @QueryParam("organisation") String organisation,
                                                  @ApiParam(value = "Context") @QueryParam("context") String context,
                                                  @ApiParam(value = "Coding System") @QueryParam("system") String system,
                                                  @ApiParam(value = "Code id") @QueryParam("code") String code,
                                                  @ApiParam(value = "Term text") @QueryParam("term") String termText
    ) throws Exception {
        LOG.debug("Get mapped term");

        Term term = new TermLogic().getTerm(organisation, context, system, code, termText);

        return Response
            .ok()
            .entity(term)
            .build();
    }

/*    @GET
    @Path("/Mappings")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.TermEndpoint.Get")
    @ApiOperation(value = "Returns Term by code in context")
    public Response getMappingsForConcept(@Context SecurityContext sc,
                                          @ApiParam(value = "Concept id") @QueryParam("concept_id") Long conceptId
    ) throws Exception {
        LOG.debug("Get mappings for term concept");

        List<TermMapping> result = new TermLogic().getMappings(conceptId);

        return Response
            .ok()
            .entity(result)
            .build();
    }
    */
}