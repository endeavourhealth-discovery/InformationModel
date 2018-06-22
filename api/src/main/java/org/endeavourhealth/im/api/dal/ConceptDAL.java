package org.endeavourhealth.im.api.dal;

import org.endeavourhealth.im.common.models.*;

import java.sql.SQLException;
import java.util.List;

public interface ConceptDAL {
    ConceptSummaryList getMRU() throws SQLException;
    ConceptSummaryList search(String searchTerm) throws SQLException;
    Concept get(Long id) throws SQLException;
    List<Attribute> getAttributes(Long id) throws SQLException;
    List<RelatedConcept> getRelatedTargets(Long id) throws SQLException;
    List<RelatedConcept> getRelatedSources(Long id) throws SQLException;
    List<ConceptReference> getRelationships() throws SQLException;
    Long save(Concept concept) throws Exception;
    Long save(RelatedConcept relatedConcept) throws Exception;
    Long save(Attribute att) throws Exception;

    void deleteAttribute(Long attributeId) throws Exception;

    void deleteRelationship(Long relId) throws Exception;
/*






    Concept getConceptByContext(String name) throws SQLException;

    Long createDraftConcept(String context) throws Exception;
    List<ConceptSummary> getSummaries(Integer page) throws SQLException;
    Concept get(Long id) throws SQLException;

    Long save(Concept concept) throws Exception;
    Long save(Relationship relationship) throws Exception;
    Long saveAttribute(Long conceptId, Long attributeId) throws Exception;
    Long saveRelationship(Long sourceId, Long targetId, Long relationshipId) throws Exception;

    List<ConceptSummary> search(String criteria) throws Exception;



    List<ConceptSummary> getAttributeOf(Long id) throws SQLException;

    */


}
