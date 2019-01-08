package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Task;
import org.endeavourhealth.im.models.TaskType;

import java.util.List;

public interface TaskDAL {
    Long createTask(String title, String description, TaskType taskType, Long conceptId);
    List<Task> getTasks(TaskType taskType);

    /*
    Long getTaskIdByTypeAndResourceId(TaskType taskType, Long resourceId);
    */
}
