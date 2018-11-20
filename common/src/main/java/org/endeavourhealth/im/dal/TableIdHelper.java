package org.endeavourhealth.im.dal;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TableIdHelper {
    private static final Logger LOG = LoggerFactory.getLogger(TableIdHelper.class);

    public static Long getNextId(Long conceptType) throws SQLException {
        if (conceptType == 1L) return getNextId("BaseConcept", 1L);
        if (conceptType == 2L) return getNextId("CodeableConcept", 1L);

        return getNextId("RecordType", 1L);
    }

    public static Long getNextId(String name) throws SQLException {
        return getNextId(name, 1L);
    }
    public static Long getNextId(String name, Long size) throws SQLException {
        Long nextId = null;
        int retries = 5;

        if (size == null)
            size = 1L;

        Connection conn = ConnectionPool.InformationModel.pop();

        while (nextId == null && retries > 0) {
            // Get the next id
            try (PreparedStatement statement = conn.prepareStatement("SELECT id FROM table_id WHERE name = ?")) {
                statement.setString(1, name);
                ResultSet rs = statement.executeQuery();
                rs.next();
                nextId = rs.getLong("id");
            }

            // Attempt to update (based on current id to prevent crossover)
            try (PreparedStatement statement = conn.prepareStatement("UPDATE table_id SET id = ? WHERE name = ? AND id = ?")) {
                statement.setLong(1, nextId + size);
                statement.setString(2, name);
                statement.setLong(3, nextId);
                Integer result = statement.executeUpdate();

                // If we failed to update, then retry
                if (result != 1) {
                    LOG.error("Could not get next ID, retrying {0} [{1}]/[{2}]...", retries, name, nextId);
                    retries --;
                    nextId = null;
                }
            }
        }
        ConnectionPool.InformationModel.push(conn);

        return nextId;
    }
}
