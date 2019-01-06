package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.*;

import java.util.List;

public class ConceptMockDAL implements ConceptDAL {
    public boolean get_Called = false;
    public Long get_Value = null;
    public Concept get_Result = null;

    public boolean getConceptByContext_Called = false;
    public String getConceptByContext_Value = null;
    public Concept getConceptByContext_Result = null;

    public boolean saveConcept_Called = false;
    public Concept saveConcept_Value = null;
    public Long saveConcept_Result = null;

    public boolean populateTct_Called = false;

    public boolean getAttributes_Called = false;
    public List<Attribute> getAttributes_Result = null;
    public boolean saveAttribute_Called = false;

    @Override
    public Concept get(Long id) throws Exception {
        get_Called = true;
        get_Value = id;
        return get_Result;
    }

    @Override
    public Concept getConceptByContext(String name) throws Exception {
        getConceptByContext_Called = true;
        getConceptByContext_Value = name;
        return getConceptByContext_Result;
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
        getAttributes_Called = true;
        return getAttributes_Result;
    }

    @Override
    public Long saveConcept(Concept concept) throws Exception {
        saveConcept_Called = true;
        saveConcept_Value = concept;
        return saveConcept_Result;
    }

    @Override
    public List<Synonym> getSynonyms(Long id) throws Exception {
        return null;
    }

    @Override
    public void saveAttribute(Long conceptId, Attribute attribute) throws Exception {
        saveAttribute_Called = true;
    }

    @Override
    public void deleteAttribute(Long id) throws Exception {

    }

    @Override
    public void deleteConcept(Long id) throws Exception {

    }

    @Override
    public void populateTct(Long id, Long superclass) throws Exception {
        populateTct_Called = true;
    }

    @Override
    public List<ConceptSummary> getSubtypes(Long id, Boolean all) throws Exception {
        return null;
    }
}
