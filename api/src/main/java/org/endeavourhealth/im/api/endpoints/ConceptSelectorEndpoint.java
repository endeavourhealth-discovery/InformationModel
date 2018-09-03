package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.logic.ConceptSelectorLogic;
import org.endeavourhealth.im.api.logic.TermLogic;
import org.endeavourhealth.im.common.models.ConceptSummaryList;
import org.endeavourhealth.im.common.models.IdText;
import org.endeavourhealth.im.common.models.Term;
import org.endeavourhealth.im.common.models.TermMapping;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.io.InputStream;
import java.util.List;
import java.util.stream.Collectors;

@Path("Code")
@Metrics(registry = "CodeMetricRegistry")
@Api(description = "API for all calls relating to Codes")
public class ConceptSelectorEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(ConceptSelectorEndpoint.class);

    @GET
    @Path("/System")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.CodeEndpoint.System.GET")
    @ApiOperation(value = "Search for a code by term")
    public Response getSystems(@Context SecurityContext sc) throws Exception {
        LOG.debug("Get systems called");

        List<IdText> result = new ConceptSelectorLogic().getSystems();

        return Response
            .ok(result)
            .build();
    }

    @GET
    @Path("/Term")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.CodeEndpoint.Term.GET")
    @ApiOperation(value = "Search for a code by term")
    public Response searchByTerm(@Context SecurityContext sc,
                                 @ApiParam(value = "Search term(s)") @QueryParam("term") String term,
                                 @ApiParam(value = "Coding systems") @QueryParam("system") List<Integer> systems,
                                 @ApiParam(value = "Active only") @QueryParam("activeOnly") Boolean activeOnly
    ) throws Exception {
        LOG.debug("Searching for [" + term + "]");
        if (activeOnly != null && activeOnly == true)
            LOG.debug("Restricted to active codes only");

        if (systems != null && systems.size() > 0)
            LOG.debug("Restricted to system(s) [" + String.join(",", systems.stream().map(Object::toString).collect(Collectors.toList())) + "]");

        ConceptSummaryList result = new ConceptSelectorLogic().search(term, activeOnly, systems);

        return Response
            .ok(result)
            .build();
    }
}