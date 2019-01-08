package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Term;
import org.endeavourhealth.im.models.TermMapping;

import java.util.List;

public class TermMockDAL implements TermDAL {
    public boolean getConceptId_Called = false;
    public Long getConceptId_Result = null;

    public boolean createTermMap_Called = false;

    public boolean getSnomedTerm_Called = false;
    public String getSnomedTerm_Result = null;

    @Override
    public Long getConceptId(String organisation, String context, String system, String code) {
        getConceptId_Called = true;
        return getConceptId_Result;
    }

    @Override
    public void createTermMap(String organisation, String context, String code, String system, Long termId) {
        createTermMap_Called = true;
    }

    @Override
    public String getSnomedTerm(String code) {
        getSnomedTerm_Called = true;
        return getSnomedTerm_Result;
    }

    @Override
    public Term getSnomedParent(String code) {
        return null;
    }

    @Override
    public String getICD10Term(String code) {
        return null;
    }

    @Override
    public String getOpcsTerm(String code) {
        return null;
    }

    @Override
    public List<TermMapping> getMappings(Long conceptId) {
        return null;
    }
}
