package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Task;
import org.endeavourhealth.im.models.TaskType;

import java.util.List;

public class TaskMockDAL implements TaskDAL {
    public Boolean createTask_Called = false;
    public Long createTask_Result = null;

    @Override
    public Long createTask(String title, String description, TaskType taskType, Long conceptId) {
        createTask_Called = true;
        return createTask_Result;
    }

    @Override
    public List<Task> getTasks(TaskType taskType) {
        return null;
    }
}
