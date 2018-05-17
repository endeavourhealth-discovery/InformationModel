package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.common.config.ConfigManager;
import org.endeavourhealth.im.client.messageProducer.FHIRMessageProducer;
import org.endeavourhealth.im.common.models.ConceptReference;
import org.endeavourhealth.im.common.models.Message;
import org.endeavourhealth.im.common.models.MessageResource;
import org.endeavourhealth.im.common.models.MessageResourceField;
import org.hl7.fhir.instance.model.Patient;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.Date;
import java.util.UUID;

public class MessageLogicTest {
    private MessageLogic messageLogic = null;

    @Before
    public void setup() {
        messageLogic = new MessageLogic(/* new MessageMockDAL()*/);
    }

    @Test
    public void validateMessageTest() {
        try {
            ConfigManager.Initialize("information-model");

            Patient patient = new Patient();
            patient.addName()
                    .addGiven("John")
                    .addFamily("Smith");
            patient.setBirthDate(new Date(1973,9, 26));
            patient.addAddress()
                    .addLine("21 Bank Top")
                    .setPostalCode("HD7 5EF");

            Message message = new FHIRMessageProducer().fhirToMessage(patient)
                .setSourceOrganisation(UUID.randomUUID().toString())
                .setSourceSystem(new ConceptReference().setContext("System.Discovery Transform"))
                .setMessageType(new ConceptReference().setContext("Message Format.FHIR.Demographics"))
                .setVersion("DSTU-2.1");

            messageLogic.isValidAndMapped(message);
        } catch (Exception e) {
            e.printStackTrace();
            Assert.fail();
        }
    }
}