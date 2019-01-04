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
    private TaskLogic taskLogic;

    public ConceptLogic() {
        this.dal = new ConceptJDBCDAL();
        this.taskLogic = new TaskLogic();
    }

    protected ConceptLogic(ConceptDAL dal, TaskLogic taskLogic) {
        this.dal = dal;
        this.taskLogic = taskLogic;
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

           taskLogic.createTask("Auto concept: "+context, TaskType.ATTRIBUTE_MODEL, newId);
        }

        return concept;
    }

    public SearchResult getMRU(Boolean includeDeprecated) throws Exception {
        return this.dal.getMRU(includeDeprecated);
    }

    public SearchResult search(String term, Integer page, Boolean includeDeprecated, List<Long> schemes, Long relatedConcept, ValueExpression expression) throws Exception {
        return this.dal.search(term, page, includeDeprecated, schemes, relatedConcept, expression);
    }

    public List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws Exception {
        List<Attribute> result = new ArrayList<>();
        List<Long> attIds = new ArrayList<>();

        List<Attribute> atts = this.dal.getAttributes(id, includeDeprecated);

        for (Attribute att : atts) {
            int idx = attIds.indexOf(att.getAttribute().getId());
            if (idx < 0) {
                att.setInheritance(att.getConcept().getId().equals(id) ? (byte)1 : (byte)0);
            } else {
                // It's been overridden (constrained)
                Attribute existing = result.get(idx);
                if (existing.getInheritance() != (byte)2)
                    existing.setInheritance(existing.getConcept().getId().equals(id) ? (byte)2 : (byte)0);
                existing.setConcept(att.getConcept());
                attIds.remove(idx);
                result.remove(existing);
                att = existing;
            }
            result.add(att);
            attIds.add(att.getAttribute().getId());
        }

        return result;
    }

    public void saveConcept(Concept concept) throws Exception {
        Long id = this.dal.saveConcept(concept);

        if (concept.isNew())
            this.dal.populateTct(id, concept.getSuperclass().getId());

        concept.setId(id);
    }

    public List<Synonym> getSynonyms(Long id) throws Exception {
        return this.dal.getSynonyms(id);
    }

    public void saveAttribute(Long conceptId, Attribute attribute) throws Exception {
        // Is this overriding an inherited attribute?
        if (!conceptId.equals(attribute.getConcept().getId())) {
            attribute.setId(null);
            attribute.setInheritance((byte)2);
        }
        this.dal.saveAttribute(conceptId, attribute);
    }

    public void deleteAttribute(Long id) throws Exception {
        this.dal.deleteAttribute(id);
    }

    public void deleteConcept(Long id) throws Exception {
        this.dal.deleteConcept(id);
    }

    public List<ConceptSummary> getSubtypes(Long id, Boolean all) throws Exception {
        return this.dal.getSubtypes(id, all);
    }
}
