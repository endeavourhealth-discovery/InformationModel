package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.endeavourhealth.im.client.messageProducer.FHIRMessageProducer;
import org.endeavourhealth.im.common.models.ConceptReference;
import org.endeavourhealth.im.common.models.Message;
import org.endeavourhealth.im.common.models.Term;
import org.hl7.fhir.instance.model.Patient;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.Date;
import java.util.UUID;

public class TermLogicTest {
    private TermLogic termLogic = null;

    @Before
    public void setup() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
        termLogic = new TermLogic();
    }

    @Test
    public void testTermLogic() throws Exception {
        Term term;
        // Known system/code, correct term
        term = termLogic.getTerm("Org1", "Observation.Code", "Snomed", "304527002", "Acute asthma (disorder)");
        printTerm(term);

        // Known system/code, incorrect term
        term = termLogic.getTerm("Org1", "Observation.Code", "Snomed", "73211009", "Patient has diabetes"); // Diabetes mellitus (disorder)
        printTerm(term);

        // Known system/unknown code/term
        term = termLogic.getTerm("Org1", "Observation.Code", "Snomed", "12345", "Unknown snomed code");
        printTerm(term);

        // Unknown system/code/term
        term = termLogic.getTerm("Org1", "Observation.Code", "Cerner", "123-45-12345", "Unknown cerner code");
        printTerm(term);
    }

    private void printTerm(Term term) {
        System.out.println(term.getId().toString() + ": " + term.getText());
    }
}