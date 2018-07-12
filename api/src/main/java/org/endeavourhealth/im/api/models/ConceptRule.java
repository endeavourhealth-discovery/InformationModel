package org.endeavourhealth.im.api.models;

public class ConceptRule {
    private String property;
    private String comparator;
    private String value;

    public String getProperty() {
        return property;
    }

    public ConceptRule setProperty(String property) {
        this.property = property;
        return this;
    }

    public String getComparator() {
        return comparator;
    }

    public ConceptRule setComparator(String comparator) {
        this.comparator = comparator;
        return this;
    }

    public String getValue() {
        return value;
    }

    public ConceptRule setValue(String value) {
        this.value = value;
        return this;
    }
}
