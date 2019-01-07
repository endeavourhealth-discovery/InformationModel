package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Task;
import org.endeavourhealth.im.models.TaskType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static org.endeavourhealth.im.dal.DALHelper.getGeneratedKey;

public class TaskJDBCDAL implements TaskDAL {
    @Override
    public Long createTask(String title, String description, TaskType taskType, Long conceptId) throws DALException {
        Task task = new Task()
                .setName(title)
                .setDescription(description)
                .setType(taskType)
                .setIdentifier(conceptId);

        return this.save(task);
        // return this.filer.storeAndApply("Endeavour Health", TransactionAction.CREATE, TransactionTable.TASK, task);
    }

    @Override
    public List<Task> getTasks(TaskType taskType) throws DALException {
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
        } catch (SQLException e) {
            throw new DALException("Error fetching tasks", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return tasks;
    }

    private Long save(Task task) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();
        String sql = (task.getId() == null)
            ? "INSERT INTO task (title, description, type, created, identifier) VALUES (?, ?, ?, ?, ?)"
            : "UPDATE task SET title = ?, description = ?, type = ?, created = ?, identifier = ? WHERE id = ?";

        if (task.getCreated() == null)
            task.setCreated(new java.util.Date());

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;
            if (task.getName() == null) stmt.setNull(i++, Types.VARCHAR); else stmt.setString(i++, task.getName());
            if (task.getDescription() == null) stmt.setNull(i++, Types.VARCHAR); else stmt.setString(i++, task.getDescription());
            if (task.getType() == null) stmt.setNull(i++, Types.TINYINT); else stmt.setByte(i++, task.getType().getValue());
            stmt.setDate(i++, new Date(task.getCreated().getTime()));
            if (task.getIdentifier() == null) stmt.setNull(i++, Types.BIGINT); else stmt.setLong(i++, task.getIdentifier());
            if (task.getId() != null) stmt.setLong(i++, task.getId());

            stmt.executeUpdate();

            if (task.getId() == null)
                task.setId(getGeneratedKey(stmt));
        } catch (SQLException e) {
            throw new DALException("Error saving task", e);

        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

        return task.getId();
    }


    /*

    @Override
    public Long getTaskIdByTypeAndResourceId(TaskType taskType, Long resourceId) throws DALException {
        Connection conn = ConnectionPool.InformationModel.pop();

        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM task WHERE type = ? and identifier = ?")) {
            stmt.setLong(1, taskType.getValue());
            stmt.setLong(2, resourceId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next())
                return rs.getLong(1);
            else
                return null;
        } catch (SQLException e) {
            throw new DALException("Error fetching task id by type and resource", e);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    */
}
