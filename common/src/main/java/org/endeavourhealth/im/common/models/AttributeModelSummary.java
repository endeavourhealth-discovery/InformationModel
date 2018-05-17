package org.endeavourhealth.im.common.models;

public class AttributeModelSummary extends DbEntity<AttributeModelSummary> {
    private String context;
    private String status;
    private String version;
    private ConceptReference inherits;

    public String getContext() {
        return context;
    }

    public AttributeModelSummary setContext(String context) {
        this.context = context;
        return this;
    }

    public String getStatus() {
        return status;
    }

    public AttributeModelSummary setStatus(String status) {
        this.status = status;
        return this;
    }

    public String getVersion() {
        return version;
    }

    public AttributeModelSummary setVersion(String version) {
        this.version = version;
        return this;
    }

    public ConceptReference getInherits() {
        return inherits;
    }

    public AttributeModelSummary setInherits(ConceptReference inherits) {
        this.inherits = inherits;
        return this;
    }
}
