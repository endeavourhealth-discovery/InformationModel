package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.api.dal.filer.IMFilerDAL;
import org.endeavourhealth.im.api.dal.filer.IMFilerJDBCDAL;
import org.endeavourhealth.im.api.models.TransactionAction;
import org.endeavourhealth.im.api.models.TransactionTable;
import org.endeavourhealth.im.common.models.Task;
import org.endeavourhealth.im.common.models.TaskType;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TaskJDBCDAL implements TaskDAL {
    private final IMFilerDAL filer;

    public TaskJDBCDAL() {
        this.filer = new IMFilerJDBCDAL();
    }

    public TaskJDBCDAL(IMFilerDAL filer) {
        this.filer = filer;
    }

    @Override
    public Long createTask(String title, String description, TaskType taskType, Long conceptId) throws Exception {
        Task task = new Task()
                .setName(title)
                .setDescription(description)
                .setType(taskType)
                .setIdentifier(conceptId);

        return this.filer.storeAndApply("Endeavour Health", TransactionAction.CREATE, TransactionTable.TASK, task);
    }

    @Override
    public List<Task> getTasks(TaskType taskType) throws SQLException {
        List<Task> tasks = new ArrayList<>();

        Connection conn = ConnectionPool.InformationModel.pop();

        String sql = "SELECT * FROM task";
        if (taskType != null)
            sql += " WHERE type = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (taskType != null)
                stmt.setByte(1, taskType.getValue());

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    tasks.add(
                        new Task()
                            .setName(rs.getString("title"))
                            .setDescription(rs.getString("description"))
                            .setType(TaskType.byValue(rs.getByte("type")))
                            .setCreated(rs.getTimestamp("created"))
                            .setId(rs.getLong("id"))
                            .setIdentifier(rs.getLong("identifier"))
                    );
                }
            }

        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return tasks;
    }
    /*

    @Override
    public Long getTaskIdByTypeAndResourceId(TaskType taskType, Long resourceId) throws SQLException {
        Connection conn = ConnectionPool.InformationModel.pop();

        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM task WHERE type = ? and identifier = ?")) {
            stmt.setLong(1, taskType.getValue());
            stmt.setLong(2, resourceId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next())
                return rs.getLong(1);
            else
                return null;
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    */
}
