package org.endeavourhealth.im.common.models;

public class ConceptReference {
    private Long id;
    private String context;

    public Long getId() {
        return id;
    }

    public ConceptReference setId(Long id) {
        this.id = id;
        return this;
    }

    public String getContext() {
        return context;
    }

    public ConceptReference setContext(String context) {
        this.context = context;
        return this;
    }
}
