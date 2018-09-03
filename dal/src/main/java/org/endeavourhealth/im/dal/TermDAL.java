package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.common.models.TermMapping;
import org.endeavourhealth.im.common.models.Term;

import java.sql.SQLException;
import java.util.List;

public interface TermDAL {
    Long getConceptId(String organisation, String context, String system, String code) throws Exception;
    void createTermMap(String organisation, String context, String code, String system, Long termId) throws Exception;

    // Term lookups
    String getSnomedTerm(String code) throws SQLException;
    Term getSnomedParent(String code) throws SQLException;
    String getICD10Term(String code);
    String getOpcsTerm(String code);

    List<TermMapping> getMappings(Long conceptId) throws Exception;

}
