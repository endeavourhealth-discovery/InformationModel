package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.*;
import org.endeavourhealth.im.models.*;

public class TermLogic {

    private TermDAL dal;
    private TaskDAL taskDAL;
    private ConceptDAL conceptDAL;
    private ConceptLogic conceptLogic;

    public TermLogic() {
        this.dal = new TermJDBCDAL();
        this.taskDAL = new TaskJDBCDAL();
        this.conceptDAL = new ConceptJDBCDAL();
        this.conceptLogic = new ConceptLogic(conceptDAL, taskDAL);
    }
    protected TermLogic(TermDAL dal, TaskDAL taskDAL, ConceptDAL conceptDAL) {
        this.dal = dal;
        this.taskDAL = taskDAL;
        this.conceptDAL = conceptDAL;
        this.conceptLogic = new ConceptLogic(conceptDAL, taskDAL);
    }

    public Term getTerm(String organisation, String context, String system, String code, String termText) throws DALException {
        // Look for existing mapping
        Long conceptId = this.dal.getConceptId(organisation, context, system, code);
        Concept concept;

        // Mapping exists, return it
        if (conceptId != null) {
            concept = this.conceptDAL.get(conceptId);
            concept.incUseCount();
            this.conceptDAL.saveConcept(concept);
        } else {
            String termConceptContext = "Term." + system + "." + code;            // Try to find based on context
            concept = this.conceptLogic.get(termConceptContext, false);

            if (concept != null) {
                conceptId = concept.getId();
            } else {
                // Try to find an official term based on code/system
                String officialTerm = getOfficialTermForCode(system, code);

                concept = new Concept()
                    .setSuperclass(new Reference(1L, "Concept"))
                    .setContext(termConceptContext);

                if (officialTerm != null) {
                    // If one was found, just use it
                    concept.setStatus(ConceptStatus.ACTIVE)
                        // .setType(new ConceptReference().setText("Class.Code"))
                        .setFullName(officialTerm);
                    this.conceptDAL.saveConcept(concept);
                    conceptId = concept.getId();
                    // TODO: Replace with attribute
                    // importParentHierarchy(conceptId, system, code);
                } else {
                    // otherwise create a draft/temporary one and associated task
                    concept.setStatus(ConceptStatus.DRAFT)
                        // TODO: Replace with relationship
                        // .setType(new ConceptReference().setText("Class.Code"))
                        .setFullName(termText);
                    this.conceptDAL.saveConcept(concept);
                    conceptId = concept.getId();
                    this.taskDAL.createTask("New draft term [" + termText + "]", termConceptContext + " => " + termText, TaskType.TERM_MAPPINGS, conceptId);
                }
            }

            // Add the mapping
            this.dal.createTermMap(organisation, context, system, code, conceptId);
        }

        return new Term()
                .setId(conceptId)
                .setText(concept.getFullName());
    }

    private String getOfficialTermForCode(String system, String code) throws DALException {
        // TODO: Replace with IM based ontologies

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
}
