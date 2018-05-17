package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.common.models.Concept;
import org.endeavourhealth.im.common.models.ConceptSummary;

import java.sql.SQLException;
import java.util.List;

public interface ConceptDAL {
    Concept getConceptByContext(String name) throws SQLException;

    Long createDraftConcept(String context) throws Exception;
    List<ConceptSummary> getSummaries(Integer page) throws SQLException;
    Concept get(Long id) throws SQLException;

    Long save(Concept concept) throws Exception;

    List<ConceptSummary> search(String criteria) throws Exception;
}
