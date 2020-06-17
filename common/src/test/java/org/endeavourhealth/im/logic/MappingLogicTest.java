package org.endeavourhealth.im.logic;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.endeavourhealth.im.models.mapping.Context;
import org.endeavourhealth.im.models.mapping.Field;
import org.endeavourhealth.im.models.mapping.Identifier;
import org.endeavourhealth.im.models.mapping.Table;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class MappingLogicTest {
    private MappingLogic mappingLogic;

    @BeforeClass
    public static void init() throws ConfigManagerException {
        ConfigManager.Initialize("information-manager");
    }

    @Before
    public void setup() {
        this.mappingLogic = new MappingLogic();
    }

    @Test
    public void getContextId_FullMatch() throws Exception {
        String actual = mappingLogic.getContextId(new Context()
            .setOrganisation(new Identifier("H12345", "https://FHIR.nhs.uk/ods", "BartsNHSTrust", "BRTS"))      // Inline Constructor style
            .setSystem(new Identifier()                                                                         // Builder style
                .setValue(":CM_System_CernerMillenium")
                .setScheme("https://DiscoveryDataService.org/InformationModel")
                .setShort("CRNR")
            )
            .setSchema(new Identifier(":CM_Schema_CDS","https://DiscoveryDataService.org/InformationModel", "CDS", "CDS"))
            .setTable(new Table("PatientAdministrativeCategory", "APC"))
        );

        Assert.assertEquals("/BRTS/CRNR/CDS/APC", actual);
    }

    @Test
    public void getContextId_PartMatch() throws Exception {
        String actual = mappingLogic.getContextId(new Context()
            .setOrganisation(new Identifier("H54321", "https://FHIR.nhs.uk/ods", "Homerton", "HMTN"))       // Inline Constructor style
            .setSystem(new Identifier()                                                                     // Builder style
                .setValue(":CM_System_CernerMillenium")
                .setScheme("https://DiscoveryDataService.org/InformationModel")
                .setShort("CRNR")
            )
            .setSchema(new Identifier(":CM_Schema_CDS","https://DiscoveryDataService.org/InformationModel", "CDS", "CDS"))
            .setTable(new Table("PatientAdministrativeCategory", "APC"))
        );

        Assert.assertEquals("/CDS/APC", actual);
    }

    @Test
    public void getPropertyConcept() throws Exception {
        String actual = mappingLogic.getPropertyConceptIri("/CDS/APC", "administrative-category_code");
        Assert.assertEquals(":LP_6u5DQjIZP5xco+5ZYlGi+zdLdIQhD3Ns6ONpYrmZ", actual);
    }

    @Test
    public void getValueConcept_Value() throws Exception {
        String contextId = "/CDS/APC";
        Field field = new Field()
            .setName("administrative-category_code")
            .setValue("1");

        String actual = mappingLogic.getValueConceptIri(contextId, field);
        Assert.assertEquals(":LPV_7B32LtcIWKX1zF2p2Bqe92PrBfABhLWou2kmQ5oN", actual);
    }

    @Test
    public void getValueConcept_Term() throws Exception {
        String contextId = "/CDS/APC";
        Field field = new Field()
            .setName("administrative-category_code")
            .setTerm("Regular day admission");

        String actual = mappingLogic.getValueConceptIri(contextId, field);
        Assert.assertEquals(":LPV_aHLZ53wZalYJ59i0qXqCs0GrOVV0S+aS1Xb/iYTy", actual);
    }


    @Test
    public void getConceptDbid() throws Exception {
        Integer actual = mappingLogic.getConceptDbid(":Snomed-CT");

        Assert.assertNotNull(actual);
        Assert.assertEquals(1, actual.intValue());
    }

    @Test
    public void getShortString_OrganisationDisplay() {
        String actual = MappingLogic.getShortString("BartsTrust");
        Assert.assertEquals("BrtsTrst", actual);
    }

    @Test
    public void getShortString_SystemConcept() {
        String actual = MappingLogic.getShortString(":CM_System_CernerMillenium");
        Assert.assertEquals("SystmCrnrMllnm", actual);
    }

    @Test
    public void getShortString_TableName() {
        String actual = MappingLogic.getShortString("PatientAdministrativeCategory");
        Assert.assertEquals("PtntAdmnstrtvCtgry", actual);
    }

    @Test
    public void getShortIdentifier_IdNoNameNoShort() {
        Identifier id = new Identifier().setValue("H12345");
        String actual = MappingLogic.getShortIdentifier(id);
        Assert.assertEquals("H12345", actual);
    }

    @Test
    public void getShortIdentifier_NameNoIdNoShort() {
        Identifier id = new Identifier().setDisplay("BartsTrust");
        String actual = MappingLogic.getShortIdentifier(id);
        Assert.assertEquals("BrtsTrst", actual);
    }

    @Test
    public void getShortIdentifier_NameAndIdNoShort() {
        Identifier id = new Identifier()
            .setValue("H12345")
            .setDisplay("BartsTrust");
        String actual = MappingLogic.getShortIdentifier(id);
        Assert.assertEquals("BrtsTrst", actual);
    }

    @Test
    public void getShortIdentifier_IdNoNameWithShort() {
        Identifier id = new Identifier().setValue("H12345").setShort("BRTSCRNR");
        String actual = MappingLogic.getShortIdentifier(id);
        Assert.assertEquals("BRTSCRNR", actual);
    }

    @Test
    public void getShortIdentifier_NameNoIdWithShort() {
        Identifier id = new Identifier().setDisplay("BartsTrust").setShort("BRTSCRNR");
        String actual = MappingLogic.getShortIdentifier(id);
        Assert.assertEquals("BRTSCRNR", actual);
    }

    @Test
    public void getShortIdentifier_NameAndIdWithShort() {
        Identifier id = new Identifier()
            .setValue("H12345")
            .setDisplay("BartsTrust")
            .setShort("BRTSCRNR");
        String actual = MappingLogic.getShortIdentifier(id);
        Assert.assertEquals("BRTSCRNR", actual);
    }
}
