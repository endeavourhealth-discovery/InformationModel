package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.StringJoiner;

public class EmisDrugExporter extends BaseExporter {
    Connection getDbConnection() throws SQLException, JsonProcessingException {
        return getDbConnection("reference-database");
    }

    String getRowCountSql() {
        return new StringJoiner(System.lineSeparator())
            .add("SELECT COUNT(1)")
            .add("FROM emis_drug_code c")
            .toString();
    }

    String getNewRowSql() {
        return new StringJoiner(System.lineSeparator())
            .add("SELECT c.code_id, c.dmd_concept_id, c.dmd_term, c.dt_last_updated")
            .add("FROM emis_drug_code c")
            .toString();
    }
}
