package org.endeavourhealth.im.client.messageProducer;

import org.endeavourhealth.im.common.models.ConceptReference;
import org.endeavourhealth.im.common.models.Message;
import org.endeavourhealth.im.common.models.MessageResource;
import org.endeavourhealth.im.common.models.MessageResourceField;
import org.hl7.fhir.instance.model.*;

import java.util.List;

public class FHIRMessageProducer {
    public Message fhirToMessage(Resource fhirResource) {

        MessageResource msgResource = getMessageResource(fhirResource);

        Message message = new Message()
                .addResource(msgResource);

        return message;
    }

    private MessageResource getMessageResource(Resource fhirResource) {
        MessageResource messageResource = new MessageResource()
                .setResourceType(new ConceptReference()
                        .setText(getResourceType(fhirResource.getResourceType()))
                );

        addResourceProperties(fhirResource.children(), messageResource, "");

        return messageResource;
    }

    private String getResourceType(ResourceType resourceType) {
        switch (resourceType) {
            case Patient:
                return "Record Type.Patient Demographics";
            default:
                return resourceType.name();
        }
    }

    private void addResourceProperties(List<Property> properties, MessageResource messageResource, String prefix) {
        for (Property property : properties) {
            if (property.getValues().size() == 0 || property.getValues().get(0) == null)
                continue;

            String fieldName = (prefix == null || prefix.isEmpty()) ? property.getName() : prefix + "." + property.getName();

            if (property.getValues().get(0).children().size() > 2) {
                addResourceProperties(property.getValues().get(0).children(), messageResource, fieldName);
            } else {
                messageResource.addField(new MessageResourceField()
                        .setName(fieldName)
                        .setValue(property.getValues().get(0).toString())
                );
            }
        }
    }
}
