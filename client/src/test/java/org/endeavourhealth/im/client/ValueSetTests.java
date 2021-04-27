package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.*;

public class ValueSetTests {
    @BeforeClass
    public static void initialize() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
    }

    @Test
    public void isSchemeCodeInVSet() throws Exception {
        Boolean actual = IMClient.isSchemeCodeInVSet("SNOMED", "123980006", "im:VSET_OCS");
        Assert.assertEquals(true, actual);
    }
}
