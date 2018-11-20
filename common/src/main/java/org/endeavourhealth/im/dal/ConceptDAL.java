package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.sql.SQLException;
import java.util.List;

public interface ConceptDAL {
    Concept get(Long id) throws Exception;
    Concept getConceptByContext(String name) throws Exception;
    SearchResult getMRU(Boolean includeDeprecated) throws Exception;
    SearchResult search(String term, Integer page, Boolean includeDeprecated, Long relatedConcept, ValueExpression expression) throws Exception;
    List<RelatedConcept> getRelated(Long id, Boolean includeDeprecated) throws Exception;
    List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws Exception;

    Long saveConcept(Concept concept) throws Exception;

    List<Synonym> getSynonyms(Long id) throws Exception;

    void saveAttribute(Attribute attribute) throws Exception;

    void deleteAttribute(Long id) throws Exception;

    void deleteConcept(Long id) throws Exception;
}
