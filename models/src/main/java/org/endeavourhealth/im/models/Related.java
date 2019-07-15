package org.endeavourhealth.im.models;

import java.util.ArrayList;
import java.util.List;

public class Related {
    private String id;
    private String name;
    private List<String> concepts = new ArrayList<>();

    public String getId() {
        return id;
    }

    public Related setId(String id) {
        this.id = id;
        return this;
    }

    public String getName() {
        return name;
    }

    public Related setName(String name) {
        this.name = name;
        return this;
    }

    public List<String> getConcepts() {
        return concepts;
    }

    public Related setConcepts(List<String> concepts) {
        this.concepts = concepts;
        return this;
    }
}
