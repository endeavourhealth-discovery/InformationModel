package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.util.List;

public interface ConceptDAL {
    Concept get(Long id) throws Exception;
    Concept getConceptByContext(String name) throws Exception;
    List<ConceptSummary> getMRU(Boolean includeDeprecated) throws Exception;
    List<ConceptSummary> search(String term, Boolean includeDeprecated, Long superclass) throws Exception;
    List<RelatedConcept> getRelated(Long id, Boolean includeDeprecated) throws Exception;
    List<Attribute> getAttributes(Long id, Long attributeConceptId, Boolean includeDeprecated) throws Exception;

    Long saveConcept(Concept concept) throws Exception;
    void saveConceptBundle(Bundle bundle) throws Exception;

    List<Synonym> getSynonyms(Long id) throws Exception;
}
