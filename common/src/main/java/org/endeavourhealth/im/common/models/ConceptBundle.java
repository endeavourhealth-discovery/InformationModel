package org.endeavourhealth.im.common.models;

import java.util.ArrayList;
import java.util.List;

public class ConceptBundle {
    private Concept concept;
    private List<Attribute> attributes = new ArrayList<>();
    private List<RelatedConcept> related = new ArrayList<>();

    public Concept getConcept() {
        return concept;
    }

    public ConceptBundle setConcept(Concept concept) {
        this.concept = concept;
        return this;
    }

    public List<Attribute> getAttributes() {
        return attributes;
    }

    public ConceptBundle setAttributes(List<Attribute> attributes) {
        this.attributes = attributes;
        return this;
    }

    public List<RelatedConcept> getRelated() {
        return related;
    }

    public ConceptBundle setRelated(List<RelatedConcept> related) {
        this.related = related;
        return this;
    }
}
