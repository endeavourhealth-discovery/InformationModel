package org.endeavourhealth.im.api.dal;

import java.sql.SQLException;

public interface TermDAL {
    Long getConceptId(String organisation, String context, String system, String code) throws Exception;

    void createTermMap(String organisation, String context, String code, String system, Long termId) throws Exception;

    // Term lookups
    String getSnomedTerm(String code) throws SQLException;
    String getICD10Term(String code);
    String getOpcsTerm(String code);
}
