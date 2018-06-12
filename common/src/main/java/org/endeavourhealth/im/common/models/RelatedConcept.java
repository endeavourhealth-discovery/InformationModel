package org.endeavourhealth.im.common.models;

public class RelatedConcept extends DbEntity<RelatedConcept> {
    private String context;
    private String relationship;

    public String getContext() {
        return context;
    }

    public RelatedConcept setContext(String context) {
        this.context = context;
        return this;
    }

    public String getRelationship() {
        return relationship;
    }

    public RelatedConcept setRelationship(String relationship) {
        this.relationship = relationship;
        return this;
    }
}
