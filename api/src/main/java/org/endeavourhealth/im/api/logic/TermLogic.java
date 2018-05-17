package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.api.dal.TermDAL;
import org.endeavourhealth.im.api.dal.TermJDBCDAL;
import org.endeavourhealth.im.common.models.Concept;
import org.endeavourhealth.im.common.models.ConceptStatus;
import org.endeavourhealth.im.common.models.TaskType;
import org.endeavourhealth.im.common.models.Term;

import java.sql.SQLException;

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
        } else {

            // Try to find an official term based on code/system
            String officialTerm = getOfficialTermForCode(system, code);
            String termConceptContext = "Term." + system + "." + code;
            concept = new Concept()
                    .setContext(termConceptContext);

            if (officialTerm != null) {
                // If one was found, just use it
                concept.setStatus(ConceptStatus.ACTIVE)
                        .setFullName(officialTerm);
                conceptId = this.conceptLogic.save(concept);
            } else {
                // otherwise create a draft/temporary one and associated task
                concept.setStatus(ConceptStatus.DRAFT)
                        .setFullName(termText);
                conceptId = this.conceptLogic.save(concept);
                this.taskLogic.createTask("New draft term", termConceptContext + " => " + termText, TaskType.TERM_MAPPINGS, conceptId);
            }

            // Add the mapping
            this.dal.createTermMap(organisation, context, system, code, conceptId);

            // Return the new id
        }

        return new Term()
                .setId(conceptId)
                .setText(concept.getFullName());
    }


    private String getOfficialTermForCode(String system, String code) throws Exception {
        String officialTerm = null;
        if (system.toLowerCase().equals("snomed"))
            officialTerm = this.dal.getSnomedTerm(code);    // Switch to official SNOMED term text
        else if (system.toLowerCase().equals("icd10"))
            officialTerm = this.dal.getICD10Term(code);     // Switch to official ICD10 term text
        else if (system.toLowerCase().equals("opcs"))
            officialTerm = this.dal.getOpcsTerm(code);      // Switch to official OPCS term text
        return officialTerm;
    }
}
