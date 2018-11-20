package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ConceptDAL;
import org.endeavourhealth.im.dal.ConceptJDBCDAL;
import org.endeavourhealth.im.models.*;
import org.w3c.dom.Attr;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ConceptLogic {
    private ConceptDAL dal;

    public ConceptLogic() {
        this.dal = new ConceptJDBCDAL();
    }
    protected ConceptLogic(ConceptDAL dal) {
        this.dal = dal;
    }

    public Concept get(Long id) throws Exception {
        return this.dal.get(id);
    }

    public Concept get(String context) throws Exception {
        return get(context, false);
    }

    public Concept get(String context, Boolean createMissing) throws Exception {
        Concept concept = this.dal.getConceptByContext(context);

        if (concept == null && createMissing) {

            concept = new Concept()
                .setSuperclass(new Reference().setId(1L).setName("Concept"))
                .setContext(context)
                .setFullName(context.replace(".", " "));
            Long newId = this.dal.saveConcept(concept);
            concept.setId(newId);

            new TaskLogic().createTask("Auto concept: "+context, TaskType.ATTRIBUTE_MODEL, newId);
        }

        return concept;
    }

    public SearchResult getMRU(Boolean includeDeprecated) throws Exception {
        return this.dal.getMRU(includeDeprecated);
    }

    public SearchResult search(String term, Integer page, Boolean includeDeprecated, Long relatedConcept, ValueExpression expression) throws Exception {
        return this.dal.search(term, page, includeDeprecated, relatedConcept, expression);
    }

    public List<RelatedConcept> getRelated(Long id, Boolean includeDeprecated) throws Exception {
        return this.dal.getRelated(id, includeDeprecated);
    }

    public List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws Exception {
        List<Attribute> result = new ArrayList<>();
        List<Long> attIds = new ArrayList<>();
        List<Long> ancestors = new ArrayList<>();
        Long attConcept = id;

        while (attConcept != null) {
            List<Attribute> atts = this.dal.getAttributes(attConcept, includeDeprecated);

            for (Attribute att : atts) {
                int idx = attIds.indexOf(att.getAttribute().getId());
                if (idx < 0) {
                    att.setInheritance(att.getConcept().getId().equals(id) ? (byte)1 : (byte)0);
                } else {
                    // It's been overridden (constrained)
                    Attribute existing = result.get(idx);
                    existing.setInheritance(existing.getConcept().getId().equals(id) ? (byte)2 : (byte)0);
                    existing.setConcept(att.getConcept());
                    attIds.remove(idx);
                    result.remove(existing);
                    att = existing;
                }
                result.add(att);
                attIds.add(att.getAttribute().getId());
            }

            // Get superclass attributes
            Concept concept = this.dal.get(attConcept);
            if (concept == null)
                throw new IndexOutOfBoundsException("Couldnt load concept " + attConcept);

            attConcept = concept.getSuperclass().getId();

            // Cyclic protection
            if (attConcept == 1 || ancestors.contains(attConcept))
                attConcept = null;
            else
                ancestors.add(attConcept);

        }

        return result;
    }

    public Long saveConcept(Concept concept) throws Exception {
        return this.dal.saveConcept(concept);
    }

    public void saveRelationship(RelatedConcept relatedConcept) throws Exception {
        throw new NotImplementedException();
    }

    public List<Synonym> getSynonyms(Long id) throws Exception {
        return this.dal.getSynonyms(id);
    }

    public void saveAttribute(Attribute attribute) throws Exception {
        this.dal.saveAttribute(attribute);
    }

    public void deleteAttribute(Long id) throws Exception {
        this.dal.deleteAttribute(id);
    }

    public void deleteConcept(Long id) throws Exception {
        this.dal.deleteConcept(id);
    }
}
