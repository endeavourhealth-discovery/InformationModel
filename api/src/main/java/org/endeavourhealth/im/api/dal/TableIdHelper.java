package org.endeavourhealth.im.api.dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TableIdHelper {
/*
    public static Long getNextId(String tableName) throws SQLException {
        Long nextId = null;

        Connection conn = ConnectionPool.InformationModel.pop();

        while (nextId == null) {
            // Get the next id
            try (PreparedStatement statement = conn.prepareStatement("SELECT id FROM table_id WHERE table_name = ?")) {
                statement.setString(1, tableName);
                ResultSet rs = statement.executeQuery();
                rs.next();
                nextId = rs.getLong("id");
            }

            // Attempt to update (based on current id to prevent crossover)
            try (PreparedStatement statement = conn.prepareStatement("UPDATE table_id SET id = ? WHERE table_name = ? AND id = ?")) {
                statement.setLong(1, nextId + 1);
                statement.setString(2, tableName);
                statement.setLong(3, nextId);
                Integer result = statement.executeUpdate();

                // If we failed to update, then retry
                if (result != 1)
                    nextId = null;
            }
        }
        ConnectionPool.InformationModel.push(conn);

        return nextId;
    }
    */
}
