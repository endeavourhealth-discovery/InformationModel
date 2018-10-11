package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.TaskDAL;
import org.endeavourhealth.im.dal.TaskJDBCDAL;
import org.endeavourhealth.im.models.Task;
import org.endeavourhealth.im.models.TaskType;

import java.util.List;

public class TaskLogic {
    private TaskDAL dal;

    public TaskLogic() {
        this.dal = new TaskJDBCDAL();
    }
    protected TaskLogic(TaskDAL dal) {
        this.dal = dal;
    }


    public void createTask(String title, TaskType taskType, Long resourceId) throws Exception {
        createTask(title, null, taskType, resourceId);
    }
    public void createTask(String title, String description, TaskType taskType, Long resourceId) throws Exception {
        dal.createTask(title, description, taskType, resourceId);
    }

    public List<Task> getTasks(TaskType taskType) throws Exception {
        return dal.getTasks(taskType);
    }

    /*
    public Long getTaskIdByTypeAndResourceId(TaskType taskType, Long resourceId) throws Exception {
        return dal.getTaskIdByTypeAndResourceId(taskType, resourceId);
    }
    */
}
