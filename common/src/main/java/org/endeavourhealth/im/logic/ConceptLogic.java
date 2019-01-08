package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.*;
import org.endeavourhealth.im.models.*;

import java.util.ArrayList;
import java.util.List;

public class ConceptLogic {
    private ConceptDAL dal;
    private TaskDAL taskDAL;

    public ConceptLogic() {
        this.dal = new ConceptJDBCDAL();
        this.taskDAL = new TaskJDBCDAL();
    }

    protected ConceptLogic(ConceptDAL dal, TaskDAL taskDAL) {
        this.dal = dal;
        this.taskDAL = taskDAL;
    }

    public Concept get(String context, Boolean createMissing) {
        Concept concept = this.dal.getConceptByContext(context);

        if (concept == null && createMissing) {

            concept = new Concept()
                .setSuperclass(new Reference().setId(1L).setName("Concept"))
                .setContext(context)
                .setFullName(context.replace(".", " "));
            Long newId = this.dal.saveConcept(concept);
            concept.setId(newId);

           taskDAL.createTask("Auto concept: "+context, null, TaskType.ATTRIBUTE_MODEL, newId);
        }

        return concept;
    }

    public List<Attribute> getAttributes(Long id, Boolean includeDeprecated) {
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

    public void saveConcept(Concept concept) {
        Long id = this.dal.saveConcept(concept);

        if (concept.isNew())
            this.dal.populateTct(id, concept.getSuperclass().getId());

        concept.setId(id);
    }

    public void saveAttribute(Long conceptId, Attribute attribute) {
        // Is this overriding an inherited attribute?
        if (!conceptId.equals(attribute.getConcept().getId())) {
            attribute.setId(null);
            attribute.setInheritance((byte)2);
        }
        this.dal.saveAttribute(conceptId, attribute);
    }
}
