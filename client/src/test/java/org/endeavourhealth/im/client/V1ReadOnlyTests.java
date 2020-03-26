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
    public void getMappedCoreCodeForSchemeCode_Unknown() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("BartsCerner", "687309281");
        assertNotNull(code);
        assertEquals("1240511000000106", code);
    }

    @Test
    public void getMappedCoreCodeForSchemeCode_Known() throws Exception {
        String code = IMClient.getMappedCoreCodeForSchemeCode("BartsCerner", "UNKNOWN");
        assertNull(code);
    }

    @Test
    public void getCodeForTypeTerm() throws Exception {
        String code = IMClient.getCodeForTypeTerm("BartsCerner", "687309281", "SARS-CoV-2 RNA DETECTED");
        assertNotNull(code);
        assertEquals("7f472a28-7374-4f49-bcd1-7fafcbb1be4c", code);
    }
}
