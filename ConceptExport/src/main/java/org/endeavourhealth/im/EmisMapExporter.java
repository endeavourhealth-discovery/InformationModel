package org.endeavourhealth.im;

import com.fasterxml.jackson.core.JsonProcessingException;

import java.sql.*;
import java.util.StringJoiner;

public class EmisMapExporter extends BaseExporter {
    Connection getDbConnection() throws SQLException, JsonProcessingException {
        return getDbConnection("reference-database");
    }

    String getRowCountSql() {
        return new StringJoiner(System.lineSeparator())
            .add("SELECT COUNT(1)")
            .add("FROM emis_clinical_code c")
            .add("LEFT JOIN emis_clinical_code_hiearchy p ON p.code_id = c.code_id")
            .toString();
    }

    String getNewRowSql() {
        return new StringJoiner(System.lineSeparator())
            .add("SELECT c.code_id, c.code_type, c.read_term, c.read_code, c.snomed_concept_id, c.snomed_description_id, c.snomed_term, c.national_code, c.national_code_category, c.national_code_description, c.adjusted_code, c.is_emis_code, c.dt_last_updated, p.parent_code_id")
            .add("FROM emis_clinical_code c")
            .add("LEFT JOIN emis_clinical_code_hiearchy p ON p.code_id = c.code_id")
            .toString();
    }
}
