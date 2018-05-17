package org.endeavourhealth.im.common.models;

import java.util.ArrayList;
import java.util.List;

public class MessageResource extends DbEntity<MessageResource> {
    private ConceptReference resourceType = new ConceptReference();
    private List<MessageResourceField> fields = new ArrayList();

    public ConceptReference getResourceType() {
        return resourceType;
    }

    public MessageResource setResourceType(ConceptReference context) {
        this.resourceType = context;
        return this;
    }

    public MessageResource addField(MessageResourceField field) {
        fields.add(field);
        return this;
    }

    public List<MessageResourceField> getFields() {
        return fields;
    }

    public MessageResource setFields(List<MessageResourceField> fields) {
        this.fields = fields;
        return this;
    }
}
