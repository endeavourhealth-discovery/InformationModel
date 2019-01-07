package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.util.List;

public interface ConceptDAL {
    Concept get(Long id) throws DALException;
    Concept getConceptByContext(String name) throws DALException;
    SearchResult getMRU(Boolean includeDeprecated) throws DALException;
    SearchResult search(String term, Integer page, Boolean includeDeprecated, List<Long> schemes, Long relatedConcept, ValueExpression expression) throws DALException;
    List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws DALException;

    Long saveConcept(Concept concept) throws DALException;

    List<Synonym> getSynonyms(Long id) throws DALException;

    void saveAttribute(Long conceptId, Attribute attribute) throws DALException;

    void deleteAttribute(Long id) throws DALException;

    void deleteConcept(Long id) throws DALException;

    void populateTct(Long id, Long superclass) throws DALException;

    List<ConceptSummary> getSubtypes(Long id, Boolean all) throws DALException;
}
