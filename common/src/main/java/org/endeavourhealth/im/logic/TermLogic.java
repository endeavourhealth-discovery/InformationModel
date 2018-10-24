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
            // Try to find based on context
            concept = this.conceptLogic.get("Term." + system, code);

            if (concept != null) {
                conceptId = concept.getId();
            } else {
                // Try to find an official term based on code/system
                String officialTerm = getOfficialTermForCode(system, code);
                String termConceptContext = "Term." + system + "." + code;
                concept = new Concept()
                    .setContext(termConceptContext);

                if (officialTerm != null) {
                    // If one was found, just use it
                    concept.setStatus(ConceptStatus.ACTIVE)
                        // TODO: Replace with relationship
                        // .setType(new ConceptReference().setText("Class.Code"))
                        .setFullName(officialTerm);
                    conceptId = this.conceptLogic.saveConcept(concept);
                    importParentHierarchy(conceptId, system, code);
                } else {
                    // otherwise create a draft/temporary one and associated task
                    concept.setStatus(ConceptStatus.DRAFT)
                        // TODO: Replace with relationship
                        // .setType(new ConceptReference().setText("Class.Code"))
                        .setFullName(termText);
                    conceptId = this.conceptLogic.saveConcept(concept);
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
            Concept concept = this.conceptLogic.get("Term.Snomed", parent.getId().toString());

            if (concept == null) {
                concept = new Concept()
                    .setContext("Term.Snomed." + parent.getId().toString())
                    // TODO: Replace with relationship
                    // .setType(new ConceptReference().setText("Class.Code"))
                    .setStatus(ConceptStatus.ACTIVE)
                    .setFullName(parent.getText());

                Long parentConceptId = this.conceptLogic.saveConcept(concept);

                RelatedConcept relatedConcept = new RelatedConcept()
                    .setSource(new Reference().setId(parentConceptId))
                    .setRelationship(new Reference().setName("Relationship.HasChild"))
                    .setTarget(new Reference().setId(conceptId));

                this.conceptLogic.saveRelationship(relatedConcept);

                importSnomedParentHierarchy(parentConceptId, parent.getId().toString());
            }
        }
    }

    public List<TermMapping> getMappings(Long conceptId) throws Exception {
        return this.dal.getMappings(conceptId);
    }

    public void ProcessTrud(InputStream codeFileStream, InputStream relFileStream) throws IOException {
        ImportCodes(codeFileStream);
        ImportRelationships(relFileStream);
    }

    private void ImportCodes(InputStream codeFileStream) throws IOException {
        // 900000000000013009 - Synonym
        // 900000000000003001 - Fully qualified name

        String[] expectedFields = {"id","effectiveTime","active","moduleId","conceptId","languageCode","typeId","term","caseSignificanceId"};
        try (BufferedReader in = new BufferedReader(new InputStreamReader(codeFileStream))) {
            int i = 10;
            String line = in.readLine();

            if (line == null)
                throw new IOException("File empty");

            String[] fields = line.split("\t");
            if (fields.length != 9) throw
                new IOException("Invalid field count (<>9)");

            if (!Arrays.asList(fields).containsAll(Arrays.asList(expectedFields)))
                throw new IOException("File does not contain correct fields");

            System.out.println("Fields: " + fields.length);

            String lastCode = "";
            while((line = in.readLine()) != null && i-- > 0) {
                fields = line.split("\t");
                if (fields[2].equals("1") && !fields[4].equals(lastCode)) {                 // Active & different
                    System.out.println(fields[4] + " - " + fields[7]);
                    lastCode = fields[4];
                }
            }
        }
    }

    private void ImportRelationships(InputStream relFileStream) throws IOException {

    }
}