package org.endeavourhealth.im.models;

public class Concept {
    private String id;
    private String name;
    private String description;
    private String scheme;
    private String code;

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

    public String getScheme() {
        return scheme;
    }

    public Concept setScheme(String scheme) {
        this.scheme = scheme;
        return this;
    }

    public String getCode() {
        return code;
    }

    public Concept setCode(String code) {
        this.code = code;
        return this;
    }
}
