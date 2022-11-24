package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.*;
import java.util.StringJoiner;

public class NewConceptExporter extends BaseExporter {
    Connection getDbConnection() throws SQLException, JsonProcessingException {
        return getDbConnection("im-database");
    }

    String getRowCountSql() {
        return "SELECT COUNT(1) FROM concept";
    }

    String getNewRowSql() {
        return new StringJoiner(System.lineSeparator())
            .add("SELECT c.dbid, c.id, c.name, c.description, s.id AS scheme, c.code, c.use_count, c.draft")
            .add("FROM concept c")
            .add("LEFT JOIN concept s ON s.dbid = c.scheme")
            .toString();
    }
}
