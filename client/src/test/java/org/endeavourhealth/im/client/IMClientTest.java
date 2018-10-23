package org.endeavourhealth.im.client;

import org.endeavourhealth.im.models.CodeScheme;
import org.endeavourhealth.im.models.Concept;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.*;

public class IMClientTest {

    @Test
    public void getConcept() throws IOException {
        Concept concept = IMClient.getConcept(CodeScheme.SNOMED.getValue(), "195967001");
        assertEquals("Asthma (disorder)", concept.getFullName());
    }

    @Test
    public void getConceptId() throws IOException {
        Long conceptId = IMClient.getConceptId(CodeScheme.SNOMED.getValue(), "195967001");
        assertEquals(1187044L, conceptId.longValue());
    }
}