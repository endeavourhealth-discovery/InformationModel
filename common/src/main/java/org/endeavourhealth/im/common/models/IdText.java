package org.endeavourhealth.im.common.models;

public class IdText extends DbEntity<IdText> {
    private String text;

    public String getText() {
        return text;
    }

    public IdText setText(String text) {
        this.text = text;
        return this;
    }
}
