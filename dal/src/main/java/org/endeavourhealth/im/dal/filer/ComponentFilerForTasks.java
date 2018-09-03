package org.endeavourhealth.im.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.dal.ConnectionPool;
import org.endeavourhealth.im.common.models.TransactionComponent;
import org.endeavourhealth.im.common.models.Task;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ComponentFilerForTasks extends ComponentFiler {
    @Override
    public Long create(TransactionComponent transactionComponent) throws Exception {
        Task task = getTask(transactionComponent);
        List<String> fieldList = getPopulatedFieldList(task);
        String paramList = getParamList(fieldList);

        String sql = "INSERT INTO task (" + String.join(",", fieldList) + ") " +
                "VALUES (" + paramList + ")";


        Connection conn = ConnectionPool.InformationModel.pop();

        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            setParameters(statement, task);
            statement.executeUpdate();
            ResultSet rs = statement.getGeneratedKeys();
            rs.next();
            return rs.getLong(1);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }

    }

    @Override
    public void update(TransactionComponent transactionComponent) throws Exception {
    }

    @Override
    public void delete(TransactionComponent transactionComponent) throws Exception {
    }

    private Task getTask(TransactionComponent transactionComponent) throws java.io.IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), Task.class);
    }

    private List<String> getPopulatedFieldList(Task task) {
        List<String> fields = new ArrayList<>();

        if (task.getType() != null) fields.add("type");
        if (task.getName() != null) fields.add("title");
        if (task.getDescription() != null) fields.add("description");
        if (task.getIdentifier() != null) fields.add("identifier");
        fields.add("created");

        return fields;
    }

    private Integer setParameters(PreparedStatement statement, Task task) throws SQLException {
        int i = 1;

        if (task.getType() != null) statement.setByte(i++, task.getType().getValue());
        if (task.getName() != null) statement.setString(i++, task.getName());
        if (task.getDescription() != null) statement.setString(i++, task.getDescription());
        if (task.getIdentifier() != null) statement.setLong(i++, task.getIdentifier());
        if (task.getCreated() != null)
            statement.setTimestamp(i++, new java.sql.Timestamp(task.getCreated().getTime()));
        else
            statement.setTimestamp(i++, new java.sql.Timestamp(new Date().getTime()));

        return i;
    }
}
