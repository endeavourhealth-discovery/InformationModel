package org.endeavourhealth.im.common.models;

public class ConceptSummary extends DbEntity<ConceptSummary> {
    private String context;
    private String status;
    private String version;
    private ConceptRelationship relationship;

    public String getContext() {
        return context;
    }

    public ConceptSummary setContext(String context) {
        this.context = context;
        return this;
    }

    public String getStatus() {
        return status;
    }

    public ConceptSummary setStatus(String status) {
        this.status = status;
        return this;
    }

    public String getVersion() {
        return version;
    }

    public ConceptSummary setVersion(String version) {
        this.version = version;
        return this;
    }

    public ConceptRelationship getRelationship() {
        return relationship;
    }

    public ConceptSummary setRelationship(ConceptRelationship relationship) {
        this.relationship = relationship;
        return this;
    }
}
