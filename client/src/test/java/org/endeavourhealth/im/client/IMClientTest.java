package org.endeavourhealth.im.client;

import org.endeavourhealth.im.common.models.Term;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.*;

public class IMClientTest {

    @Test
    public void getTerm() throws IOException {
        Term term = IMClient.getTerm("Org1", "Observation.Code", "Snomed", "304527002", "Acute asthma (disorder)");
        printTerm(term);
    }

    private void printTerm(Term term) {
        System.out.println(term.getId().toString() + ": " + term.getText());
    }
}