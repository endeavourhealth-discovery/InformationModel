package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.TermMapping;
import org.endeavourhealth.im.models.Term;

import java.sql.SQLException;
import java.util.List;

public interface TermDAL {
    Long getConceptId(String organisation, String context, String system, String code) throws DALException;
    void createTermMap(String organisation, String context, String code, String system, Long termId) throws DALException;

    // Term lookups
    String getSnomedTerm(String code) throws DALException;
    Term getSnomedParent(String code) throws DALException;
    String getICD10Term(String code);
    String getOpcsTerm(String code);

    List<TermMapping> getMappings(Long conceptId) throws DALException;

}
