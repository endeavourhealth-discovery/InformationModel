package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.*;
import org.endeavourhealth.im.dal.SchemaMappingsJDBCDAL;
import org.endeavourhealth.im.logic.SchemaMappingsLogic;
import org.endeavourhealth.im.models.SchemaMapping;
import org.endeavourhealth.im.models.SearchResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("SchemaMappings")
@Metrics(registry = "SchemaMappingsMetricRegistry")
@Api(tags={"SchemaMappings"})
public class SchemaMappingsEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(SchemaMappingsEndpoint.class);

    @GET
    @Path("/RecordTypes")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.SchemaMappingsEndpoint.RecordTypes.GET")
    @ApiOperation(value = "Returns list of record type concepts", response = SearchResult.class)
    public Response getRecordTypes(@Context SecurityContext sc) {
        LOG.debug("Get record type concepts");

        SearchResult result = new SchemaMappingsJDBCDAL().getRecordTypes();

        return Response
            .ok()
            .entity(result)
            .build();
    }

    @GET
    @Path("/{conceptId}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.SchemaMappingsEndpoint.{conceptId}.GET")
    @ApiOperation(value = "Returns mappings for given concept", response = SchemaMapping.class, responseContainer = "List")
    public Response getById(@Context SecurityContext sc,
                            @ApiParam(name="Concept id", required = true) @PathParam("conceptId") Long conceptId
    ) {
        LOG.debug("Get schema mappings for concept");

        List<SchemaMapping> result = new SchemaMappingsLogic().getSchemaMappings(conceptId);

        return Response
            .ok()
            .entity(result)
            .build();
    }
}
