package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.StringJoiner;

public class TPPMapExporter extends BaseExporter {
    Connection getDbConnection() throws SQLException, JsonProcessingException {
        return getDbConnection("reference-database");
    }

    String getRowCountSql() {
        return new StringJoiner(System.lineSeparator())
            .add("SELECT COUNT(1)")
            .add("FROM tpp_ctv3_to_snomed")
            .toString();
    }

    String getNewRowSql() {
        return new StringJoiner(System.lineSeparator())
            .add("SELECT *")
            .add("FROM tpp_ctv3_to_snomed")
            .toString();
    }
}
