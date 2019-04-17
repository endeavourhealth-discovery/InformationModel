package org.endeavourhealth.im.client;

import org.junit.Test;

import static org.junit.Assert.*;

public class IMClientTest {

    @Test
    public void getConceptIdForSchemeCode_SNOMED() throws Exception {
        Integer dbid = IMClient.getConceptIdForSchemeCode("SNOMED", "195967001");
        assertNotNull(dbid);
        assertEquals(16452, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getConceptIdForSchemeCode("READ2", "H33..");
        assertNotNull(dbid);
        assertEquals(754594, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_Unknown() throws Exception {
        Integer dbid = IMClient.getConceptIdForSchemeCode("INVALID", "INVALID");
        assertNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_SNOMED() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForSchemeCode("SNOMED", "195967001");
        assertNotNull(dbid);
        assertEquals(16452, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForSchemeCode("BartsCerner", "162592560");
        assertNotNull(dbid);
        assertEquals(999063, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_NoMap() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForSchemeCode("OPCS4", "A01");
        assertNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_Unknown() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForSchemeCode("INVALID", "INVALID");
        assertNull(dbid);
    }

    @Test
    public void getMappedConceptIdForTypeTerm_Known() throws Exception {
        Integer dbid = IMClient.getMappedConceptIdForTypeTerm("EncounterType", "practice nurse clinic");
        assertNotNull(dbid);
        assertEquals(999506, dbid.intValue());
    }

    @Test
    public void getMappedConceptIdForTypeTerm_TypeUnknown() throws Exception {
        Integer dbid = IMClient.getMappedConceptIdForTypeTerm("UnknownType", "practice nurse clinic");
        assertNull(dbid);
    }

    @Test
    public void getMappedConceptIdForTypeTerm_TermKnown() throws Exception {
        Integer dbid = IMClient.getMappedConceptIdForTypeTerm("EncounterType", "This is an unknown term");
        assertNull(dbid);
    }
}
