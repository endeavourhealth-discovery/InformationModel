package org.endeavourhealth.im.models;

public class Term extends DbEntity<Term> {
    private String text;

    public String getText() {
        return text;
    }

    public Term setText(String text) {
        this.text = text;
        return this;
    }
}
