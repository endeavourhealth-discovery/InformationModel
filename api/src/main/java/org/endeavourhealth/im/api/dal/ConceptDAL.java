package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.common.models.Concept;
import org.endeavourhealth.im.common.models.ConceptSummary;
import org.endeavourhealth.im.common.models.RelatedConcept;
import org.endeavourhealth.im.common.models.Relationship;

import java.sql.SQLException;
import java.util.List;

public interface ConceptDAL {
    Concept getConceptByContext(String name) throws SQLException;

    Long createDraftConcept(String context) throws Exception;
    List<ConceptSummary> getSummaries(Integer page) throws SQLException;
    Concept get(Long id) throws SQLException;

    Long save(Concept concept) throws Exception;
    Long save(Relationship relationship) throws Exception;

    List<ConceptSummary> search(String criteria) throws Exception;

    List<RelatedConcept> getRelatedTargets(Long id) throws SQLException;
    List<RelatedConcept> getRelatedSources(Long id) throws SQLException;

    List<ConceptSummary> getAttributes(Long id) throws SQLException;
}
