package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.util.List;

public interface ConceptDAL {
    Concept get(Long id) throws Exception;
    Concept getConceptByContext(String name) throws Exception;
    SearchResult getMRU(Boolean includeDeprecated) throws Exception;
    SearchResult search(String term, Integer page, Boolean includeDeprecated, List<Long> schemes, Long relatedConcept, ValueExpression expression) throws Exception;
    List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws Exception;

    Long saveConcept(Concept concept) throws Exception;

    List<Synonym> getSynonyms(Long id) throws Exception;

    void saveAttribute(Long conceptId, Attribute attribute) throws Exception;

    void deleteAttribute(Long id) throws Exception;

    void deleteConcept(Long id) throws Exception;

    void populateTct(Long id, Long superclass) throws Exception;

    List<ConceptSummary> getSubtypes(Long id, Boolean all) throws Exception;
}
