package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.*;

public class ReadOnlyTests {

    @BeforeClass
    public static void initialize() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
    }

    @Test
    public void getConceptDbidForSchemeCode_SNOMED() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("SNOMED", "195967001");
        assertNotNull(dbid);
        assertEquals(123732, dbid.intValue());
    }

    @Test
    public void getConceptIdForSchemeCode_SNOMED() throws Exception {
        String id = IMClient.getConceptIdForSchemeCode("SNOMED", "195967001");
        assertNotNull(id);
        assertEquals("SN_195967001", id);
    }

    @Test
    public void getConceptDbidForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("READ2", "H33..");
        assertNotNull(dbid);
        assertEquals(1098404, dbid.intValue());
    }

    @Test
    public void getConceptDbidForSchemeCode_FHIR() throws Exception {
        Integer dbid = IMClient.getConceptDbidForSchemeCode("FHIR_AS", "noshow");
        assertNotNull(dbid);
        assertEquals(1335326, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptDbidForSchemeCode_SNOMED() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("SNOMED", "195967001");
        assertNotNull(dbid);
        assertEquals(16507, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptDbidForSchemeCode_Known() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("BartsCerner", "162592560");
        assertNotNull(dbid);
        assertEquals(1473193, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptDbidForSchemeCode_FHIR() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("FHIR_RS", "D19");
        assertNotNull(dbid);
        assertEquals(1210789, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptDbidForSchemeCode_NoMap() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForSchemeCode("OPCS4", "A01");
        assertNull(dbid);
    }

    @Test
    public void getCodeForConceptDbid_SNOMED() throws Exception {
        String code = IMClient.getCodeForConceptDbid(123732);
        assertNotNull(code);
        assertEquals("195967001", code);
    }

    @Test
    public void getCodeForConceptDbid_READ() throws Exception {
        String code = IMClient.getCodeForConceptDbid(1098404);
        assertNotNull(code);
        assertEquals("H33..", code);
    }

    @Test
    public void getConceptDbidForTypeTerm_Known() throws Exception {
        Integer dbid = IMClient.getConceptDbidForTypeTerm("DCE_type_of_encounter", "practice nurse clinic");
        assertNotNull(dbid);
        assertEquals(1335073, dbid.intValue());
    }

    @Test
    public void getConceptDbidForTypeTerm_KnownSpecialChars() throws Exception {
        Integer dbid = IMClient.getConceptDbidForTypeTerm("DCE_type_of_encounter", "test {fail} 50%");
        assertNotNull(dbid);
        assertEquals(1335073, dbid.intValue());
    }

    @Test
    public void getMappedCoreConceptDbidForTypeTerm_Known() throws Exception {
        Integer dbid = IMClient.getMappedCoreConceptDbidForTypeTerm("DCE_type_of_encounter", "practice nurse clinic");
        assertNotNull(dbid);
        assertEquals(1335073, dbid.intValue());
    }
}
