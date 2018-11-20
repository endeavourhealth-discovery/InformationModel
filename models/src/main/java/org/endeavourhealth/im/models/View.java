package org.endeavourhealth.im.models;

public class View extends DbEntity<View> {
    private String name;
    private String description;

    public String getName() {
        return name;
    }

    public View setName(String name) {
        this.name = name;
        return this;
    }

    public String getDescription() {
        return description;
    }

    public View setDescription(String description) {
        this.description = description;
        return this;
    }
}
