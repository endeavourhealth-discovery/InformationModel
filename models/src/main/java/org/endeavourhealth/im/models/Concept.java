package org.endeavourhealth.im.models;

public class Concept {
    private String id;
    private String name;
    private String description;
    private Short status;

    public String getId() {
        return id;
    }

    public Concept setId(String id) {
        this.id = id;
        return this;
    }

    public String getName() {
        return name;
    }

    public Concept setName(String name) {
        this.name = name;
        return this;
    }

    public String getDescription() {
        return description;
    }

    public Concept setDescription(String description) {
        this.description = description;
        return this;
    }

    public Short getStatus() {
        return status;
    }

    public Concept setStatus(Short status) {
        this.status = status;
        return this;
    }
}
