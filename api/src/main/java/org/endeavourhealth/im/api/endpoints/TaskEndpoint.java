package org.endeavourhealth.im.api.endpoints;

import com.codahale.metrics.annotation.Timed;
import com.datastax.driver.mapping.annotations.Query;
import io.astefanutti.metrics.aspectj.Metrics;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.endeavourhealth.im.api.logic.MessageLogic;
import org.endeavourhealth.im.api.logic.TaskLogic;
import org.endeavourhealth.im.common.models.Message;
import org.endeavourhealth.im.common.models.Task;
import org.endeavourhealth.im.common.models.TaskType;
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
@Api(description = "API for all calls relating to Tasks")
public class TaskEndpoint {
    private static final Logger LOG = LoggerFactory.getLogger(TaskEndpoint.class);
/*
    @GET
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(absolute = true, name = "InformationModel.TaskEndpoint.Get")
    @ApiOperation(value = "Returns workflow manager tasks optionally by type")
    public Response get(@Context SecurityContext sc,
                             @ApiParam(value = "Task type filter (optional)") @QueryParam("TaskTypeId") Byte taskTypeId
    ) throws Exception {
        LOG.debug("Get tasks called");

        List<Task> tasks = new TaskLogic().getTasks(TaskType.byValue(taskTypeId));

        return Response
            .ok()
            .entity(tasks)
            .build();
    }
    */
}