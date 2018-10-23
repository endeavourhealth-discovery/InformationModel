package org.endeavourhealth.im.client;

import org.endeavourhealth.im.models.Concept;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.*;

public class IMClientTest {

    @Test
    public void getConcept() throws IOException {
        Concept concept = IMClient.getConcept(5301L, "195967001");
        assertEquals("Asthma (disorder)", concept.getFullName());
    }
}