package org.endeavourhealth.im.common.models;

public class Reference extends DbEntity<Reference> {
    private String name;

    public Reference() {}
    public Reference(Long id, String name) {
        this.setId(id);
        this.setName(name);
    }

    public String getName() {
        return name;
    }

    public Reference setName(String name) {
        this.name = name;
        return this;
    }
}
