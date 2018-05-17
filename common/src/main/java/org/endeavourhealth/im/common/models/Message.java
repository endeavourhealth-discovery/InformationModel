package org.endeavourhealth.im.common.models;

import java.util.ArrayList;
import java.util.List;

public class Message extends DbEntity<Message> {
    private String sourceOrganisation;
    private ConceptReference sourceSystem = new ConceptReference();
    private String version;
    private ConceptReference messageType = new ConceptReference();
    private List<MessageResource> resources = new ArrayList();

    public String getSourceOrganisation() {
        return sourceOrganisation;
    }

    public Message setSourceOrganisation(String sourceOrganisation) {
        this.sourceOrganisation = sourceOrganisation;
        return this;
    }

    public ConceptReference getSourceSystem() {
        return sourceSystem;
    }

    public Message setSourceSystem(ConceptReference sourceSystem) {
        this.sourceSystem = sourceSystem;
        return this;
    }

    public String getVersion() {
        return version;
    }

    public Message setVersion(String version) {
        this.version = version;
        return this;
    }

    public ConceptReference getMessageType() {
        return messageType;
    }

    public Message setMessageType(ConceptReference messageType) {
        this.messageType = messageType;
        return this;
    }

    public Message addResource(MessageResource resource) {
        this.resources.add(resource);
        return this;
    }

    public List<MessageResource> getResources() {
        return resources;
    }

    public Message setResources(List<MessageResource> resources) {
        this.resources = resources;
        return this;
    }
}
