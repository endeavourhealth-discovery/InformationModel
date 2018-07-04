package org.endeavourhealth.im.common.models;

public class ValueSummary extends DbEntity<ValueSummary> {
    private String name;
    private ConceptReference concept;

    public String getName() {
        return name;
    }

    public ValueSummary setName(String name) {
        this.name = name;
        return this;
    }

    public ConceptReference getConcept() {
        return concept;
    }

    public ValueSummary setConcept(ConceptReference concept) {
        this.concept = concept;
        return this;
    }
}
