package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.api.dal.TermDAL;
import org.endeavourhealth.im.api.dal.TermJDBCDAL;
import org.endeavourhealth.im.api.models.TermMapping;
import org.endeavourhealth.im.common.models.*;

import java.sql.SQLException;
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
                        .setFullName(officialTerm);
                    conceptId = this.conceptLogic.save(concept);
                    importParentHierarchy(conceptId, system, code);
                } else {
                    // otherwise create a draft/temporary one and associated task
                    concept.setStatus(ConceptStatus.DRAFT)
                        .setFullName(termText);
                    conceptId = this.conceptLogic.save(concept);
                    this.taskLogic.createTask("New draft term", termConceptContext + " => " + termText, TaskType.TERM_MAPPINGS, conceptId);
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
        String officialTerm = null;
        if (system.toLowerCase().equals("snomed"))
            officialTerm = this.dal.getSnomedTerm(code);    // Switch to official SNOMED term text
        else if (system.toLowerCase().equals("icd10"))
            officialTerm = this.dal.getICD10Term(code);     // Switch to official ICD10 term text
        else if (system.toLowerCase().equals("opcs"))
            officialTerm = this.dal.getOpcsTerm(code);      // Switch to official OPCS term text
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
                    .setStatus(ConceptStatus.ACTIVE)
                    .setFullName(parent.getText());

                Long parentConceptId = this.conceptLogic.save(concept);

                Relationship relationship = new Relationship()
                    .setSource(parentConceptId)
                    .setRelationship(ConceptRelationship.HAS_CHILD.getId())
                    .setTarget(conceptId);

                this.conceptLogic.save(relationship);

                importSnomedParentHierarchy(parentConceptId, parent.getId().toString());
            }
        }
    }

}
