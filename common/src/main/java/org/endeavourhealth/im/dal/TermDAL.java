package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.TermMapping;
import org.endeavourhealth.im.models.Term;

import java.util.List;

public interface TermDAL {
    Long getConceptId(String organisation, String context, String system, String code);
    void createTermMap(String organisation, String context, String code, String system, Long termId);

    // Term lookups
    String getSnomedTerm(String code);
    Term getSnomedParent(String code);
    String getICD10Term(String code);
    String getOpcsTerm(String code);

    List<TermMapping> getMappings(Long conceptId);

}
