package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.common.models.ConceptSummaryList;
import org.endeavourhealth.im.common.models.IdText;

import java.util.List;

public interface ConceptSelectorDAL {
    ConceptSummaryList search(String searchTerm, Boolean activeOnly, List<Integer> systems) throws Exception;
    List<IdText> getCodeSystems() throws Exception;
}
