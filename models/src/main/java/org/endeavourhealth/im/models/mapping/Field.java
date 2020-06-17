package org.endeavourhealth.im.models.mapping;

public class Field {
    private String name;
    private String value;
    private String term;

    public Field() {
    }

    public String getName() {
        return name;
    }

    public Field setName(String name) {
        this.name = name;
        return this;
    }

    public String getValue() {
        return value;
    }

    public Field setValue(String value) {
        this.value = value;
        return this;
    }

    public String getTerm() {
        return term;
    }

    public Field setTerm(String term) {
        this.term = term;
        return this;
    }
}
