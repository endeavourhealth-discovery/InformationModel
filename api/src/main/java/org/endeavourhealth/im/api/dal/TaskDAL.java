package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.common.models.Task;
import org.endeavourhealth.im.common.models.TaskType;

import java.sql.SQLException;
import java.util.List;

public interface TaskDAL {
    Long createTask(String title, String description, TaskType taskType, Long conceptId) throws Exception;

    Long getTaskIdByTypeAndResourceId(TaskType taskType, Long resourceId) throws SQLException;
    List<Task> getTasks(TaskType taskType) throws SQLException;
}
