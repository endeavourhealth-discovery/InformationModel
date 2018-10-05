package org.endeavourhealth.im.common.models;

public class Bundle {
    private Concept concept;
    private ConceptEdits edits;

    public Concept getConcept() {
        return concept;
    }

    public Bundle setConcept(Concept concept) {
        this.concept = concept;
        return this;
    }

    public ConceptEdits getEdits() {
        return edits;
    }

    public Bundle setEdits(ConceptEdits edits) {
        this.edits = edits;
        return this;
    }
}
