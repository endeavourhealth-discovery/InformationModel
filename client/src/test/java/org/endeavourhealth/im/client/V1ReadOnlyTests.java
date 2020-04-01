package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.*;

public class V1ReadOnlyTests {

    @BeforeClass
    public static void initialize() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
    }

    @Test
    public void getMappedCoreCodeForSchemeCode_Known() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("BartsCerner", "687309281");
        assertNotNull(code);
        assertEquals("1240511000000106", code);
    }

    @Test
    public void getMappedCoreCodeForSchemeCode_Unknown() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("BartsCerner", "UNKNOWN");
        assertNull(code);
    }

    @Test
    public void getMappedCoreCodeForSchemeCode_NotSnomed() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("BartsCerner", "163127655");
        assertEquals("DS_BC_1503405", code);
    }

    @Test
    public void getMappedCoreCodeForSchemeCode_IsSnomed() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("READ2", "SLF01");
        assertEquals("276008", code);
    }


    @Test
    public void getMappedCoreCodeForSchemeCode_SnomedOnly_NotSnomed() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("BartsCerner", "163127655", true);
        assertNull(code);
    }

    @Test
    public void getMappedCoreCodeForSchemeCode_SnomedOnly_IsSnomed() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("READ2", "SLF01", true);
        assertEquals("276008", code);
    }


    @Test
    public void getCodeForTypeTerm() throws Exception {
        String code = IMClient.getCodeForTypeTerm("BartsCerner", "687309281", "SARS-CoV-2 RNA DETECTED");
        assertNotNull(code);
        assertEquals("Fr1gvtFQJAIPqpoHK", code);
    }
}
