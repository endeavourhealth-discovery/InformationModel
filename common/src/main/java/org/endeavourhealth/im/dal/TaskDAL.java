package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Task;
import org.endeavourhealth.im.models.TaskType;

import java.sql.SQLException;
import java.util.List;

public interface TaskDAL {
    Long createTask(String title, String description, TaskType taskType, Long conceptId) throws DALException;
    List<Task> getTasks(TaskType taskType) throws DALException;

    /*
    Long getTaskIdByTypeAndResourceId(TaskType taskType, Long resourceId) throws DALException;
    */
}
