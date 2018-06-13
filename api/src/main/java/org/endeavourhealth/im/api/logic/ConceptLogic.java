package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.api.dal.ConceptDAL;
import org.endeavourhealth.im.api.dal.ConceptJDBCDAL;
import org.endeavourhealth.im.common.models.*;

import java.sql.SQLException;
import java.util.List;

public class ConceptLogic {
    private ConceptDAL dal;

    public ConceptLogic() {
        this.dal = new ConceptJDBCDAL();
    }
    protected ConceptLogic(ConceptDAL dal) {
        this.dal = dal;
    }

    public boolean validateAndCreateDraft(ConceptReference ref) throws Exception {
        return validateAndCreateDraft(ref, false);
    }

    public boolean validateAndCreateDraftWithTask(ConceptReference ref) throws Exception {
        return validateAndCreateDraft(ref, true);
    }

    private boolean validateAndCreateDraft(ConceptReference ref, boolean createTaskIfInvalid) throws Exception {
        if (ref == null || ref.getId() != null || ref.getContext() == null || ref.getContext().isEmpty())
            return true;

        Concept concept = dal.getConceptByContext(ref.getContext());
        if (concept != null) {
            ref.setId(concept.getId());
            return true;
        } else {
            Long id = dal.createDraftConcept(ref.getContext());
            if (createTaskIfInvalid)
                new TaskLogic().createTask("(AUTO) - " + ref.getContext(), TaskType.ATTRIBUTE_MODEL, id);
            ref.setId(id);
            return false;
        }
    }

    public List<ConceptSummary> getSummaries(Integer page) throws Exception {
        return this.dal.getSummaries(page);
    }

    public Concept get(Long id) throws Exception {
        return this.dal.get(id);
    }

    public Concept get(String context) throws Exception {
        return this.dal.getConceptByContext(context);
    }

    public Long save(Concept concept) throws Exception {
        return this.dal.save(concept);
    }

    public Long save(Relationship relationship) throws Exception {
        return this.dal.save(relationship);
    }

    public List<ConceptSummary> search(String criteria) throws Exception {
        return this.dal.search(criteria);
    }

    public List<RelatedConcept> getRelatedTargets(Long id) throws Exception {
        return this.dal.getRelatedTargets(id);
    }

    public List<RelatedConcept> getRelatedSources(Long id) throws Exception {
        return this.dal.getRelatedSources(id);
    }

    public List<ConceptSummary> getAttributes(Long id) throws Exception {
        return this.dal.getAttributes(id);
    }

    public List<ConceptSummary> getAttributeOf(Long id) throws Exception {
        return this.dal.getAttributeOf(id);
    }

    public List<ConceptSummary> getRelationships() throws Exception {
        return this.dal.getRelationships();
    }
}
