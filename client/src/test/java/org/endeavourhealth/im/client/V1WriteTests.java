package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.*;

public class V1WriteTests {

    @BeforeClass
    public static void initialize() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
    }

    @Test
    public void getCodeForTypeTermUnknown() throws Exception {
        String code = IMClient.getCodeForTypeTerm("BartsCerner", "687309281", "SARS-CoV-2 RNA DETECTED (misspell)", true);
        assertNotNull(code);
        assertEquals("7f472a28-7374-4f49-bcd1-7fafcbb1be4c", code);
    }

    @Test
    public void getCodeForTypeTermKnown() throws Exception {
        String code = IMClient.getCodeForTypeTerm("BartsCerner", "687309281", "SARS-CoV-2 RNA DETECTED (misspell)");
        assertNotNull(code);
        assertEquals("171304d4-b707-4bf3-8179-f9d34a58f1fb", code);
    }
}
