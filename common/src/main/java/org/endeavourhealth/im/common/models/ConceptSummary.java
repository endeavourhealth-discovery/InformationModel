package org.endeavourhealth.im.common.models;

public class ConceptSummary extends DbEntity<ConceptSummary> {
    private String name;
    private String context;
    private ConceptStatus status;
    private Float version;
    private Boolean synonym;

    public String getName() {
        return name;
    }

    public ConceptSummary setName(String name) {
        this.name = name;
        return this;
    }

    public String getContext() {
        return context;
    }

    public ConceptSummary setContext(String context) {
        this.context = context;
        return this;
    }

    public ConceptStatus getStatus() {
        return status;
    }

    public ConceptSummary setStatus(ConceptStatus status) {
        this.status = status;
        return this;
    }

    public Float getVersion() {
        return version;
    }

    public ConceptSummary setVersion(Float version) {
        this.version = version;
        return this;
    }

    public Boolean getSynonym() {
        return synonym;
    }

    public ConceptSummary setSynonym(Boolean synonym) {
        this.synonym = synonym;
        return this;
    }
}
