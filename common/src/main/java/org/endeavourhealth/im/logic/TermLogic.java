package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.TermDAL;
import org.endeavourhealth.im.dal.TermJDBCDAL;
import org.endeavourhealth.im.models.*;

import java.io.*;
import java.util.Arrays;
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
            this.conceptLogic.saveConcept(concept);
        } else {
            String termConceptContext = "Term." + system + "." + code;            // Try to find based on context
            concept = this.conceptLogic.get(termConceptContext);

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
                    this.conceptLogic.saveConcept(concept);
                    conceptId = concept.getId();
                    // TODO: Replace with attribute
                    // importParentHierarchy(conceptId, system, code);
                } else {
                    // otherwise create a draft/temporary one and associated task
                    concept.setStatus(ConceptStatus.DRAFT)
                        // TODO: Replace with relationship
                        // .setType(new ConceptReference().setText("Class.Code"))
                        .setFullName(termText);
                    this.conceptLogic.saveConcept(concept);
                    conceptId = concept.getId();
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

    public List<TermMapping> getMappings(Long conceptId) throws Exception {
        return this.dal.getMappings(conceptId);
    }

    private String getOfficialTermForCode(String system, String code) throws Exception {
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
