package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.util.List;

public class ConceptMockDAL implements ConceptDAL {
    public Concept conceptResult = null;

    public Boolean getCalled = false;
    public Long getValue = null;

    public Boolean getConceptByContextCalled = false;
    public String getConceptByContextValue = null;

    public Boolean saveConceptCalled = false;
    public Concept saveConceptValue = null;

    public Long saveResult = null;

    public Boolean populateTctCalled = false;

    public Boolean getAttributesCalled = false;
    public List<Attribute> getAttributesResult = null;

    @Override
    public Concept get(Long id) throws Exception {
        getCalled = true;
        getValue = id;
        return conceptResult;
    }

    @Override
    public Concept getConceptByContext(String name) throws Exception {
        getConceptByContextCalled = true;
        getConceptByContextValue = name;
        return conceptResult;
    }

    @Override
    public SearchResult getMRU(Boolean includeDeprecated) throws Exception {
        return null;
    }

    @Override
    public SearchResult search(String term, Integer page, Boolean includeDeprecated, List<Long> schemes, Long relatedConcept, ValueExpression expression) throws Exception {
        return null;
    }

    @Override
    public List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws Exception {
        getAttributesCalled = true;
        return getAttributesResult;
    }

    @Override
    public Long saveConcept(Concept concept) throws Exception {
        saveConceptCalled = true;
        saveConceptValue = concept;
        return saveResult;
    }

    @Override
    public List<Synonym> getSynonyms(Long id) throws Exception {
        return null;
    }

    @Override
    public void saveAttribute(Long conceptId, Attribute attribute) throws Exception {

    }

    @Override
    public void deleteAttribute(Long id) throws Exception {

    }

    @Override
    public void deleteConcept(Long id) throws Exception {

    }

    @Override
    public void populateTct(Long id, Long superclass) throws Exception {
        populateTctCalled = true;
    }

    @Override
    public List<ConceptSummary> getSubtypes(Long id, Boolean all) throws Exception {
        return null;
    }
}
