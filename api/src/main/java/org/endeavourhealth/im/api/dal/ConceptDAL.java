package org.endeavourhealth.im.api.dal;

//import org.endeavourhealth.im.common.models.ConceptRuleSet;
import org.endeavourhealth.im.common.models.*;

import java.util.List;

public interface ConceptDAL {
    ConceptSummaryList getMRU() throws Exception;
    ConceptSummaryList search(String searchTerm) throws Exception;
    Concept get(Long id) throws Exception;
    Concept getConceptByContext(String name) throws Exception;
    List<Attribute> getAttributes(Long id) throws Exception;
    List<RelatedConcept> getRelatedTargets(Long id) throws Exception;
    List<RelatedConcept> getRelatedSources(Long id) throws Exception;
    List<ConceptReference> getRelationships() throws Exception;
    Long save(Concept concept) throws Exception;
    Long save(Attribute att) throws Exception;
    Long save(RelatedConcept relatedConcept) throws Exception;

    void deleteAttribute(Long attributeId) throws Exception;

    void deleteRelationship(Long relId) throws Exception;

    List<ConceptRuleSet> getConceptRuleSets(Long conceptId, String resourceType) throws Exception;
/*







    Long createDraftConcept(String context) throws Exception;
    List<ConceptSummary> getSummaries(Integer page) throws SQLException;
    Concept get(Long id) throws SQLException;

    Long saveAttribute(Long conceptId, Long attributeId) throws Exception;
    Long saveRelationship(Long sourceId, Long targetId, Long relationshipId) throws Exception;

    List<ConceptSummary> search(String criteria) throws Exception;



    List<ConceptSummary> getAttributeOf(Long id) throws SQLException;

    */


}
