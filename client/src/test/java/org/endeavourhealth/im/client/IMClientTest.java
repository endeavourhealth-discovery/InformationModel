package org.endeavourhealth.im.client;

import org.junit.Test;

import static org.junit.Assert.*;

public class IMClientTest {

    @Test
    public void getConceptIdForSchemeCode_SNOMED() throws Exception {
        Integer dbid = IMClient.getConceptIdForSchemeCode("SNOMED", "195967001");
        assertNotNull(dbid);
        assertEquals(16507, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getConceptIdForSchemeCode("READ2", "H33..");
        assertNotNull(dbid);
        assertEquals(844436, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_FHIR() throws Exception {
        Integer dbid = IMClient.getConceptIdForSchemeCode("FHIR_AS", "noshow");
        assertNotNull(dbid);
        assertEquals(1210928, dbid.intValue());
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
        assertEquals(16507, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForSchemeCode("BartsCerner", "162592560");
        assertNotNull(dbid);
        assertEquals(1192134, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_FHIR() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForSchemeCode("FHIR_RS", "D19");
        assertNotNull(dbid);
        assertEquals(1210789, dbid.intValue());
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
    public void getCodeForConceptId_SNOMED() throws Exception {
        String code = IMClient.getCodeForConceptId(16452);
        assertNotNull(code);
        assertEquals("195811008", code);
    }

    @Test
    public void getCodeForConceptId_READ() throws Exception {
        String code = IMClient.getCodeForConceptId(844436);
        assertNotNull(code);
        assertEquals("H33..", code);
    }

    @Test
    public void getConceptIdForTypeTerm_Known() throws Exception {
        Integer dbid = IMClient.getConceptIdForTypeTerm("DCE_Type_of_encounter", "practice nurse clinic");
        assertNotNull(dbid);
        assertEquals(1194447, dbid.intValue());
    }

    @Test
    public void getConceptIdForTypeTerm_TypeUnknown() throws Exception {
        Integer dbid = IMClient.getConceptIdForTypeTerm("UnknownType", "practice nurse clinic");
        assertNull(dbid);
    }

    @Test
    public void getConceptIdForTypeTerm_TermKnown() throws Exception {
        Integer dbid = IMClient.getConceptIdForTypeTerm("DCE_Type_of_encounter", "This is an unknown term");
        assertNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForTypeTerm_Known() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForTypeTerm("DCE_Type_of_encounter", "practice nurse clinic");
        assertNotNull(dbid);
        assertEquals(1194447, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForTypeTerm_TypeUnknown() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForTypeTerm("UnknownType", "practice nurse clinic");
        assertNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForTypeTerm_TermKnown() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptIdForTypeTerm("DCE_Type_of_encounter", "This is an unknown term");
        assertNull(dbid);
    }
}
