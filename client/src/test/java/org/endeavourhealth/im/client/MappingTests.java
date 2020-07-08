package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.endeavourhealth.im.models.mapping.*;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class MappingTests {

    @BeforeClass
    public static void initialize() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
    }

    @Test
    public void getMapColumnRequest_KnownContext() throws Exception {
        MapResponse actual = IMClient.getMapProperty(
            "CM_Org_Barts",
            "CM_Sys_Cerner",
            "CDS",
            "emergency",
            "department_type"
        );

        Assert.assertEquals("/CDS/EMGCY/DPT_TYP", actual.getNodeData().getNode());
        Assert.assertEquals("DM_aAndEDepartmentType", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnRequest_UnknownContext() throws Exception {
        MapResponse actual = IMClient.getMapProperty(
            "CM_Org_Linfit",
            "CM_Sys_TPP",
            "CDS",
            "emergency",
            "department_type"
        );

        Assert.assertNotNull(actual);
        Assert.assertNotNull(actual.getNodeData());
        Assert.assertNotNull(actual.getNodeData().getNode());
        Assert.assertNotNull(actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextKnownValue() throws Exception {
        MapResponse actual = IMClient.getMapPropertyValue(
            "CM_Org_Barts",
            "CM_Sys_Cerner",
            "CDS",
            "emergency",
            "department_type",
            "03",
            "CM_NHS_DD"
        );

        Assert.assertEquals("CM_AEDepType3", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextUnknownValue() throws Exception {
        MapResponse actual = IMClient.getMapPropertyValue(
            "CM_Org_Barts",
            "CM_Sys_Cerner",
            "CDS",
            "emergency",
            "department_type",
            "99",
            "CM_NHS_DD"
        );

        Assert.assertTrue(actual.getConcept().getIri().startsWith("LPV_Brt_Crn_CDS_emr_dpr_99_"));
    }

    @Test
    public void getMapColumnValueRequest_KnownContextKnownValue_Format() throws Exception {
        MapResponse actual = IMClient.getMapPropertyValue(
            "CM_Org_Barts",
            "CM_Sys_Cerner",
            "CDS",
            "emergency",
            "treatment_function_code",
            "1164554",
            "CM_BartCernerCode"
        );

        Assert.assertEquals("BC_1164554", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextUnknownValue_Format() throws Exception {
        MapResponse actual = IMClient.getMapPropertyValue(
            "CM_Org_Barts",
            "CM_Sys_Cerner",
            "CDS",
            "emergency",
            "treatment_function_code",
            "99",
            "CM_BartCernerCode"
        );

        Assert.assertEquals("BC_99", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextKnownTerm() throws Exception {
        MapResponse actual = IMClient.getMapPropertyValue(
            "CM_Org_BHRUT",
            "CM_Sys_Medway",
            "MedwayBI",
            "PMI",
            "CAUSEOFDEATH",
            "Covid-19"
        );

        Assert.assertTrue(actual.getConcept().getIri().startsWith("LPV_BHR_Mdw_Mdw_PMI_CAU_Cvd_"));
    }

    @Test
    public void getMapColumnValueRequest_KnownContextUnknownTerm() throws Exception {
        MapResponse actual = IMClient.getMapPropertyValue(
            "CM_Org_BHRUT",
            "CM_Sys_Medway",
            "MedwayBI",
            "PMI",
            "CAUSEOFDEATH 1c",
            "Benign prostatic hyperplasia"
        );

        Assert.assertTrue(actual.getConcept().getIri().startsWith("LPV_BHR_Mdw_Mdw_PMI_CAU_Bng_"));
    }
}
