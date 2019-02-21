/*
package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.endeavourhealth.im.models.CodeScheme;
import org.endeavourhealth.im.models.Concept;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.*;

public class IMClientTest {
    @BeforeClass
    public static void setup() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
    }

    @Test
    public void getConcept() throws Exception {
        Concept concept = IMClient.getConcept(CodeScheme.SNOMED.getValue(), "195967001");
        assertEquals("Asthma (disorder)", concept.getFullName());
    }

    @Test
    public void getConceptId() throws Exception {
        Long conceptId = IMClient.getConceptId(CodeScheme.SNOMED.getValue(), "195967001");
        assertEquals(21034L, conceptId.longValue());
    }

    @Test
    public void getConceptByContext() throws Exception {
        Long conceptId = IMClient.getConceptId("DM+D.VMP");
        assertEquals(5326L, conceptId.longValue());
    }

    @Test
    public void getMissingConceptByContext() throws Exception {
        Long conceptId = IMClient.getOrCreateConceptId("MadeUpStatus.Temporary");
        assertNotNull(conceptId);
    }
}*/
