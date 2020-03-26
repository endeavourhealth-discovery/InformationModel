package org.endeavourhealth.im.client;

import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.*;

public class ReadWriteTests {

    @Test
    public void getConceptIdForSchemeCode_SNOMED() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("SNOMED", "195967001");
        assertNotNull(dbid);
        assertEquals(16507, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("READ2", "H33..");
        assertNotNull(dbid);
        assertEquals(844436, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_FHIR() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("FHIR_AS", "noshow");
        assertNotNull(dbid);
        assertEquals(1210928, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_CodeUnknown() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("EMIS_LOCAL", "NewCode1");
        assertNull(dbid);
    }

    @Test
    public void getConceptIdForSchemeCode_CodeUnknown_AutoCreate() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("EMIS_LOCAL", "NewCode2", "New emis local code", true);
        assertNotNull(dbid);
    }

    @Test
    public void getConceptIdForSchemeCode_BothUnknown() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("INVALID", "INVALID");
        assertNull(dbid);
    }

    @Test(expected = IOException.class)
    public void getConceptIdForSchemeCode_BothUnknown_AutoCreate() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("INVALID", "INVALID", "New emis local code", true);
        assertNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_SNOMED() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("SNOMED", "195967001");
        assertNotNull(dbid);
        assertEquals(16507, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("BartsCerner", "162592560");
        assertNotNull(dbid);
        assertEquals(1473193, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_FHIR() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("FHIR_RS", "D19");
        assertNotNull(dbid);
        assertEquals(1210789, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_NoMap() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("OPCS4", "A01");
        assertNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForSchemeCode_Unknown() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("INVALID", "INVALID");
        assertNull(dbid);
    }

    @Test
    public void getCodeForConceptId_SNOMED() throws Exception {
        String code = IMClient.getCodeForConceptDbid(16452);
        assertNotNull(code);
        assertEquals("195811008", code);
    }

    @Test
    public void getCodeForConceptId_READ() throws Exception {
        String code = IMClient.getCodeForConceptDbid(844436);
        assertNotNull(code);
        assertEquals("H33..", code);
    }

    @Test
    public void getConceptIdForTypeTerm_Known() throws Exception {
        Integer dbid = IMClient.getConceptDbidForTypeTerm("DCE_type_of_encounter", "practice nurse clinic");
        assertNotNull(dbid);
        assertEquals(1473373, dbid.intValue());
    }

    @Test
    public void getConceptIdForTypeTerm_TypeUnknown() throws Exception {
        Integer dbid = IMClient.getConceptDbidForTypeTerm("UnknownType", "practice nurse clinic");
        assertNull(dbid);
    }

    @Test
    public void getConceptIdForTypeTerm_TypeUnknown_AutoCreate() throws Exception {
        Integer dbid = IMClient.getConceptDbidForTypeTerm("UnknownType", "practice nurse clinic", true);
        assertNull(dbid);
    }

    @Test
    public void getConceptIdForTypeTerm_TermUnknown() throws Exception {
        Integer dbid = IMClient.getConceptDbidForTypeTerm("DCE_type_of_encounter", "This is an unknown term");
        assertNull(dbid);
    }

    @Test
    public void getConceptIdForTypeTerm_TermUnknownAutoCreate() throws Exception {
        Integer dbid = IMClient.getConceptDbidForTypeTerm("DCE_type_of_encounter", "This is an unknown term", true);
        assertNotNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForTypeTerm_Known() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForTypeTerm("DCE_type_of_encounter", "practice nurse clinic");
        assertNotNull(dbid);
        assertEquals(1473373, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptIdForTypeTerm_TypeUnknown() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForTypeTerm("UnknownType", "practice nurse clinic");
        assertNull(dbid);
    }

    @Test
    public void getMappedCoreConceptIdForTypeTerm_TermUnknown() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForTypeTerm("DCE_type_of_encounter", "This is an unknown term");
        assertNull(dbid);
    }
}
