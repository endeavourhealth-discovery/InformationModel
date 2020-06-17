package org.endeavourhealth.im.client;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.common.config.ConfigManagerException;
import org.endeavourhealth.im.models.mapping.Context;
import org.endeavourhealth.im.models.mapping.Field;
import org.endeavourhealth.im.models.mapping.Identifier;
import org.endeavourhealth.im.models.mapping.Table;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import static org.junit.Assert.*;

public class MappingTests {

    @BeforeClass
    public static void initialize() throws ConfigManagerException {
        ConfigManager.Initialize("information-model");
    }

    @Test
    public void getContextId_FullMatch() throws Exception {
        String actual = IMClient.getMappingContextId(new Context()
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
        String actual = IMClient.getMappingContextId(new Context()
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
        String actual = IMClient.getPropertyConceptIri("/CDS/APC", "administrative-category_code");
        Assert.assertEquals(":LP_rY1MbsvvPFFeXd+uiIGXPttt4f9UXH/+BbPzAkom", actual);
    }

    @Test
    public void getValueConcept_Value() throws Exception {
        String contextId = "/CDS/APC";
        Field field = new Field()
            .setName("administrative-category_code")
            .setValue("1");

        String actual = IMClient.getValueConceptIri(contextId, field);
        Assert.assertEquals(":LPV_7B32LtcIWKX1zF2p2Bqe92PrBfABhLWou2kmQ5oN", actual);
    }

    @Test
    public void getValueConcept_Term() throws Exception {
        String contextId = "/CDS/APC";
        Field field = new Field()
            .setName("administrative-category_code")
            .setTerm("Regular day admission");

        String actual = IMClient.getValueConceptIri(contextId, field);
        Assert.assertEquals(":LPV_aHLZ53wZalYJ59i0qXqCs0GrOVV0S+aS1Xb/iYTy", actual);
    }

    @Test
    public void getConceptId() throws Exception {
        Integer actual = IMClient.getConceptDbid(":Snomed-CT");

        Assert.assertNotNull(actual);
        Assert.assertEquals(1, actual.intValue());
    }
}
