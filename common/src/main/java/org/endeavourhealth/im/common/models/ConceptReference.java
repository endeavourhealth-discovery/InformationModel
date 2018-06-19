package org.endeavourhealth.im.common.models;

public class ConceptReference {
    private Long id;
    private String text;

    public Long getId() {
        return id;
    }

    public ConceptReference setId(Long id) {
        this.id = id;
        return this;
    }

    public String getText() {
        return text;
    }

    public ConceptReference setText(String text) {
        this.text = text;
        return this;
    }
}
