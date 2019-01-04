package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Task;
import org.endeavourhealth.im.models.TaskType;

import java.sql.SQLException;
import java.util.List;

public class TaskMockDAL implements TaskDAL {
    public Boolean createTaskCalled = false;
    public Long createTaskResult = null;

    @Override
    public Long createTask(String title, String description, TaskType taskType, Long conceptId) throws Exception {
        createTaskCalled = true;
        return createTaskResult;
    }

    @Override
    public List<Task> getTasks(TaskType taskType) throws SQLException {
        return null;
    }
}
