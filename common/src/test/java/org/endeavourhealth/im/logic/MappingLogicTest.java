package org.endeavourhealth.im.logic;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.endeavourhealth.im.models.mapping.*;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class MappingLogicTest {
    private MappingLogic mappingLogic;
    private MappingMockDal mappingMockDal;

    @BeforeClass
    public static void init() throws ConfigManagerException {
      //  ConfigManager.Initialize("information-model-test");
    }

    @Before
    public void setup() {
        this.mappingMockDal = new MappingMockDal();
        this.mappingLogic = new MappingLogic(mappingMockDal);

    }

    @Test
    public void getMapColumnRequest_KnownContext() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode()
            .setNode("/CDS/EMGCY/DPT_TYP")

        );

        mappingMockDal.setGetNodePropertyConceptResult(new ConceptIdentifiers()
            .setIri("DM_aAndEDepartmentType")
        );

        MapRequest request = new MapRequest()
            .setMapColumnRequest(
                new MapColumnRequest()
                    .setProvider("CM_Org_Barts")
                    .setSystem("CM_Sys_Cerner")
                    .setSchema("CDS")
                    .setTable("emergency")
                    .setColumn("department_type")
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertEquals("/CDS/EMGCY/DPT_TYP", actual.getNode().getNode());
        Assert.assertEquals("DM_aAndEDepartmentType", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnRequestTarget_KnownContext() throws Exception {
        mappingMockDal.setGetNodeResult(new MapNode()
            .setNode("/CDS/EMGCY/ARRVL_MD")
            .setTarget("DS_FHIR_RFT_N")
        );

        mappingMockDal.setGetNodePropertyConceptResult(new ConceptIdentifiers()
            .setIri("DM_arrivalMode")
        );

        MapRequest request = new MapRequest()
                .setMapColumnRequest(
                        new MapColumnRequest()
                                .setProvider("CM_Org_Barts")
                                .setSystem("CM_Sys_Cerner")
                                .setSchema("CDS")
                                .setTable("emergency")
                                .setColumn("arrival_mode")
                                .setTarget("DS_FHIR_RFT_N")
                );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertEquals("/CDS/EMGCY/ARRVL_MD", actual.getNode().getNode());
        Assert.assertEquals("DM_arrivalMode", actual.getConcept().getIri());
        Assert.assertEquals("DS_FHIR_RFT_N", actual.getNode().getTarget());
    }

    @Test
    public void getMapColumnRequestWrongTarget_KnownContext() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode()
            .setNode("/CDS/EMGCY/ARRVL_MD")
            .setTarget("DS_FHIR_RFT_N")
        );

        MapRequest request = new MapRequest()
                .setMapColumnRequest(
                        new MapColumnRequest()
                                .setProvider("CM_Org_Barts")
                                .setSystem("CM_Sys_Cerner")
                                .setSchema("CDS")
                                .setTable("emergency")
                                .setColumn("arrival_mode")
                                .setTarget("Wrong")
                );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertEquals("/CDS/EMGCY/ARRVL_MD", actual.getNode().getNode());
        Assert.assertNull( actual.getConcept());
        Assert.assertEquals("DS_FHIR_RFT_N", actual.getNode().getTarget());
    }

    @Test
    public void getMapColumnRequest_UnknownContext() throws Exception {
        MapRequest request = new MapRequest()
            .setMapColumnRequest(
                new MapColumnRequest()
                    .setProvider("CM_Org_Linfit")
                    .setSystem("CM_Sys_TPP")
                    .setSchema("CDS")
                    .setTable("emergency")
                    .setColumn("Unknown")
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertNull(actual);

    }

    @Test
    public void getMapColumnValueRequest_KnownContextKnownValue() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode());

        mappingMockDal.setGetValueNodeResult(new MapValueNode()
            .setFunction("Lookup()")
        );

        mappingMockDal.setGetValueNodeConceptResult(new ConceptIdentifiers()
            .setIri("CM_AEDepType3")
        );

        MapRequest request = new MapRequest()
            .setMapColumnValueRequest(
                new MapColumnValueRequest()
                    .setProvider("CM_Org_Barts")
                    .setSystem("CM_Sys_Cerner")
                    .setSchema("CDS")
                    .setTable("emergency")
                    .setColumn("department_type")
                    .setValue(new MapValueRequest()
                        .setCode("03")
                        .setScheme("CM_NHS_DD")
                    )
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertEquals("CM_AEDepType3", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextKnownValueShortcut() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode());

        mappingMockDal.setGetValueNodeResult(new MapValueNode()
            .setFunction("Lookup()")
        );

        mappingMockDal.setGetValueNodeConceptResult(new ConceptIdentifiers()
            .setIri("CM_AEDepType3")
        );

        MapRequest request = new MapRequest()
            .setMapColumnValueRequest(
                new MapColumnValueRequest()
                    .setProvider("CM_Org_Barts")
                    .setSystem("CM_Sys_Cerner")
                    .setSchema("CDS")
                    .setTable("emergency")
                    .setColumn("department_type")
                    .setValue(new MapValueRequest()
                        .setCode("03")
                        .setScheme("CM_NHS_DD")
                    )
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertEquals("CM_AEDepType3", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextUnknownValue() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode());

        mappingMockDal.setGetValueNodeResult(new MapValueNode()
            .setFunction("Lookup()")
        );

        mappingMockDal.setGetValueNodeConceptResult(new ConceptIdentifiers()
            .setIri("LPV_Brt_Crn_CDS_emr_dpr_99_")
        );

        MapRequest request = new MapRequest()
            .setMapColumnValueRequest(
                new MapColumnValueRequest()
                    .setProvider("CM_Org_Barts")
                    .setSystem("CM_Sys_Cerner")
                    .setSchema("CDS")
                    .setTable("emergency")
                    .setColumn("department_type")
                    .setValue(new MapValueRequest()
                        .setCode("99")
                        .setScheme("CM_NHS_DD")
                    )
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertTrue(actual.getConcept().getIri().startsWith("LPV_Brt_Crn_CDS_emr_dpr_99_"));
    }

    @Test
    public void getMapColumnValueRequest_KnownContextKnownValue_Format() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode());

        mappingMockDal.setGetValueNodeResult(new MapValueNode()
            .setFunction("Lookup()")
        );

        mappingMockDal.setGetValueNodeConceptResult(new ConceptIdentifiers()
            .setIri("BC_1164554")
        );

        MapRequest request = new MapRequest()
            .setMapColumnValueRequest(
                new MapColumnValueRequest()
                    .setProvider("CM_Org_Barts")
                    .setSystem("CM_Sys_Cerner")
                    .setSchema("CDS")
                    .setTable("emergency")
                    .setColumn("treatment_function_code")
                    .setValue(new MapValueRequest()
                        .setCode("1164554")
                        .setScheme("BartsCerner")
                    )
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertEquals("BC_1164554", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextUnknownValue_Format() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode());

        mappingMockDal.setGetValueNodeResult(new MapValueNode()
            .setFunction("Lookup()")
        );

        mappingMockDal.setGetValueNodeConceptResult(new ConceptIdentifiers()
            .setIri("BC_99")
        );

        MapRequest request = new MapRequest()
            .setMapColumnValueRequest(
                new MapColumnValueRequest()
                    .setProvider("CM_Org_Barts")
                    .setSystem("CM_Sys_Cerner")
                    .setSchema("CDS")
                    .setTable("emergency")
                    .setColumn("treatment_function_code")
                    .setValue(new MapValueRequest()
                        .setCode("99")
                        .setScheme("BartsCerner")
                    )
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertEquals("BC_99", actual.getConcept().getIri());
    }

    @Test
    public void getMapColumnValueRequest_KnownContextKnownTerm() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode());

        mappingMockDal.setGetValueNodeResult(new MapValueNode()
            .setFunction("Lookup()")
        );

        mappingMockDal.setGetValueNodeConceptResult(new ConceptIdentifiers()
            .setIri("LPV_BHR_Mdw_Mdw_PMI_CAU_Cvd_")
        );

        MapRequest request = new MapRequest()
            .setMapColumnValueRequest(
                new MapColumnValueRequest()
                    .setProvider("CM_Org_BHRUT")
                    .setSystem("CM_Sys_Medway")
                    .setSchema("MedwayBI")
                    .setTable("PMI")
                    .setColumn("CAUSEOFDEATH")
                    .setValue(new MapValueRequest()
                        .setTerm("Covid-19")
                    )
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertTrue(actual.getConcept().getIri().startsWith("LPV_BHR_Mdw_Mdw_PMI_CAU_Cvd_"));
    }

    @Test
    public void getMapColumnValueRequest_KnownContextUnknownTerm() throws Exception {

        mappingMockDal.setGetNodeResult(new MapNode());

        mappingMockDal.setGetValueNodeResult(new MapValueNode()
            .setFunction("Lookup()")
        );

        mappingMockDal.setGetValueNodeConceptResult(new ConceptIdentifiers()
            .setIri("LPV_BHR_Mdw_Mdw_PMI_CAU_Cpd_")
        );

        MapRequest request = new MapRequest()
            .setMapColumnValueRequest(
                new MapColumnValueRequest()
                    .setProvider("CM_Org_BHRUT")
                    .setSystem("CM_Sys_Medway")
                    .setSchema("MedwayBI")
                    .setTable("PMI")
                    .setColumn("CAUSEOFDEATH 1B")
                    .setValue(new MapValueRequest()
                        .setTerm("Copd")
                    )
            );

        MapResponse actual = mappingLogic.getMapping(request);

        Assert.assertTrue(actual.getConcept().getIri().startsWith("LPV_BHR_Mdw_Mdw_PMI_CAU_Cpd_"));
    }

    @Test
    public void getShortString() {
        MappingLogic.getShortString("99");
    }
}
