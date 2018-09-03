package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.dal.TermDAL;
import org.endeavourhealth.im.dal.TermJDBCDAL;
import org.endeavourhealth.im.api.models.TermMapping;
import org.endeavourhealth.im.common.models.*;

import java.util.List;

public class TermLogic {

    private TermDAL dal;
    private TaskLogic taskLogic;
    private ConceptLogic conceptLogic;

    public TermLogic() {
        this.dal = new TermJDBCDAL();
        this.taskLogic = new TaskLogic();
        this.conceptLogic = new ConceptLogic();
    }
    protected TermLogic(TermDAL dal, TaskLogic taskLogic, ConceptLogic conceptLogic) {
        this.dal = dal;
        this.taskLogic = taskLogic;
        this.conceptLogic = conceptLogic;
    }


    public Term getTerm(String organisation, String context, String system, String code, String termText) throws Exception {
        // Look for existing mapping
        Long conceptId = this.dal.getConceptId(organisation, context, system, code);
        Concept concept;

        // Mapping exists, return it
        if (conceptId != null) {
            concept = this.conceptLogic.get(conceptId);
            concept.incUseCount();
            this.conceptLogic.save(concept);
        } else {
            // Try to find based on context
            String termConceptContext = "Term." + system + "." + code;
            concept = this.conceptLogic.get(termConceptContext);

            if (concept != null) {
                conceptId = concept.getId();
            } else {
                // Try to find an official term based on code/system
                String officialTerm = getOfficialTermForCode(system, code);
                concept = new Concept()
                    .setContext(termConceptContext);

                if (officialTerm != null) {
                    // If one was found, just use it
                    concept.setStatus(ConceptStatus.ACTIVE)
                        // TODO: Replace with relationship
                        // .setType(new ConceptReference().setText("Class.Code"))
                        .setFullName(officialTerm);
                    conceptId = this.conceptLogic.save(concept);
                    importParentHierarchy(conceptId, system, code);
                } else {
                    // otherwise create a draft/temporary one and associated task
                    concept.setStatus(ConceptStatus.DRAFT)
                        // TODO: Replace with relationship
                        // .setType(new ConceptReference().setText("Class.Code"))
                        .setFullName(termText);
                    conceptId = this.conceptLogic.save(concept);
                    this.taskLogic.createTask("New draft term [" + termText + "]", termConceptContext + " => " + termText, TaskType.TERM_MAPPINGS, conceptId);
                }
            }

            // Add the mapping
            this.dal.createTermMap(organisation, context, system, code, conceptId);
        }

        return new Term()
                .setId(conceptId)
                .setText(concept.getFullName());
    }

    private String getOfficialTermForCode(String system, String code) throws Exception {
        String officialTerm = null;
        switch (system.toLowerCase()) {
            case "snomed":
                officialTerm = this.dal.getSnomedTerm(code);    // Switch to official SNOMED term text
                break;
            case "icd10":
                officialTerm = this.dal.getICD10Term(code);     // Switch to official ICD10 term text
                break;
            case "opcs":
                officialTerm = this.dal.getOpcsTerm(code);      // Switch to official OPCS term text
                break;
        }
        return officialTerm;
    }

    private void importParentHierarchy(Long conceptId, String system, String code) throws Exception {
        if (system.toLowerCase().equals("snomed"))
            importSnomedParentHierarchy(conceptId, code);
    }


    private void importSnomedParentHierarchy(Long conceptId, String code) throws Exception {
        Term parent = this.dal.getSnomedParent(code);
        if (parent != null) {
            String context = "Term.Snomed." + parent.getId().toString();
            Concept concept = this.conceptLogic.get(context);

            if (concept == null) {
                concept = new Concept()
                    .setContext(context)
                    // TODO: Replace with relationship
                    // .setType(new ConceptReference().setText("Class.Code"))
                    .setStatus(ConceptStatus.ACTIVE)
                    .setFullName(parent.getText());

                Long parentConceptId = this.conceptLogic.save(concept);

                RelatedConcept relatedConcept = new RelatedConcept()
                    .setSourceId(parentConceptId)
                    .setRelationship(new ConceptReference().setText("Relationship.HasChild"))
                    .setTargetId(conceptId);

                this.conceptLogic.save(relatedConcept);

                importSnomedParentHierarchy(parentConceptId, parent.getId().toString());
            }
        }
    }

    public List<TermMapping> getMappings(Long conceptId) throws Exception {
        return this.dal.getMappings(conceptId);
    }
}
