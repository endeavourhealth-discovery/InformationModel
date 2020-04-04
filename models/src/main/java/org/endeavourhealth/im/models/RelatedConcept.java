package org.endeavourhealth.im.models;

public class RelatedConcept {
    private Concept relationship;
    private Concept concept;

    public Concept getRelationship() {
        return relationship;
    }

    public RelatedConcept setRelationship(Concept relationship) {
        this.relationship = relationship;
        return this;
    }

    public Concept getConcept() {
        return concept;
    }

    public RelatedConcept setConcept(Concept concept) {
        this.concept = concept;
        return this;
    }
}
