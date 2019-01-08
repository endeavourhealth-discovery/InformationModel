package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.dal.TaskJDBCDAL;
import org.endeavourhealth.im.models.Task;
import org.endeavourhealth.im.models.TaskType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.SecurityContext;
import java.util.List;

@Path("/Task")
@Metrics(registry = "TaskMetricRegistry")
@Api(tags={"Task"})
public class TaskEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(TaskEndpoint.class);

    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.TaskEndpoint.Get")
    @ApiOperation(value = "Returns workflow manager tasks optionally by type")
    public Response get(@Context SecurityContext sc,
                             @ApiParam(value = "Task type filter (optional)") @QueryParam("TaskTypeId") Byte taskTypeId
    ) {
        LOG.debug("Get tasks called");

        List<Task> tasks = new TaskJDBCDAL().getTasks(TaskType.byValue(taskTypeId));

        return Response
            .ok()
            .entity(tasks)
            .build();
    }
}