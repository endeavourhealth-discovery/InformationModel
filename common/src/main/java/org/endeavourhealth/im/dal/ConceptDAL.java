package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.util.List;

public interface ConceptDAL {
    Concept get(Long id);
    Concept getConceptByContext(String name);
    SearchResult getMRU(Boolean includeDeprecated);
    SearchResult search(String term, Integer page, Boolean includeDeprecated, List<Long> schemes, Long relatedConcept, ValueExpression expression);
    List<Attribute> getAttributes(Long id, Boolean includeDeprecated);

    Long saveConcept(Concept concept);

    List<Synonym> getSynonyms(Long id);

    void saveAttribute(Long conceptId, Attribute attribute);

    void deleteAttribute(Long id);

    void deleteConcept(Long id);

    void populateTct(Long id, Long superclass);

    List<ConceptSummary> getSubtypes(Long id, Boolean all);
}
