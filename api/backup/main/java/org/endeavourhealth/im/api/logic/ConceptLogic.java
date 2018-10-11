package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ConceptDAL;
import org.endeavourhealth.im.dal.ConceptJDBCDAL;
import org.endeavourhealth.im.models.*;

import java.util.ArrayList;
import java.util.List;

public class ConceptLogic {
    private ConceptDAL dal;

    public ConceptLogic() {
        this.dal = new ConceptJDBCDAL();
    }
    protected ConceptLogic(ConceptDAL dal) {
        this.dal = dal;
    }

    public ConceptSummaryList getMRU() throws Exception {
        return dal.getMRU();
    }

    public ConceptSummaryList search(String searchTerm) throws Exception {
        return dal.search(searchTerm);
    }

    public Concept get(Long id) throws Exception {
        return this.dal.get(id);
    }

    public Concept get(String context) throws Exception {
        return this.dal.getConceptByContext(context);
    }

    public ConceptBundle getBundle(Long id) throws Exception {
        return new ConceptBundle()
            .setConcept(this.dal.get(id))
            .setRelated(this.getRelated(id));
    }

    public List<RelatedConcept> getRelated(Long id) throws Exception {
        List<RelatedConcept> result = new ArrayList<>();
        result.addAll(this.getRelatedTargets(id));
        result.addAll(this.getRelatedSources(id));
        return result;
    }

    public List<RelatedConcept> getRelatedTargets(Long id) throws Exception {
        return this.dal.getRelatedTargets(id);
    }

    public List<RelatedConcept> getRelatedSources(Long id) throws Exception {
        return this.dal.getRelatedSources(id);
    }

    public List<ConceptReference> getRelationships() throws Exception {
        return this.dal.getRelationships();
    }

    public Long save(Concept concept) throws Exception {
        concept.setId(this.dal.save(concept));
        return concept.getId();
    }

    public Long save(RelatedConcept relatedConcept) throws Exception {
        relatedConcept.setId(this.dal.save(relatedConcept));
        return relatedConcept.getId();
    }

    public void save(ConceptBundle conceptBundle) throws Exception {
        Long conceptId = this.dal.save(conceptBundle.getConcept());

        for(RelatedConcept rel : conceptBundle.getRelated()) {
            if (rel.getTargetId() == null)
                rel.setTargetId(conceptId);
            else if (rel.getSourceId() == null)
                rel.setSourceId(conceptId);
            this.dal.save(rel);
        }

        for(Long relId: conceptBundle.getDeletedRelatedIds())
            this.dal.deleteRelationship(relId);
    }

    /*

















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









    public List<ConceptSummary> search(String criteria) throws Exception {
        return this.dal.search(criteria);
    }



    public List<ConceptSummary> getAttributeOf(Long id) throws Exception {
        return this.dal.getAttributeOf(id);
    }


    public Long addAttribute(Long conceptId, Long attributeId) throws Exception {
        return this.dal.saveAttribute(conceptId, attributeId);
    }

    public Long addRelationship(Long sourceId, Long targetId, Long relationshipId) throws Exception {
        return this.dal.saveRelationship(sourceId, targetId, relationshipId);
    }
*/
}
