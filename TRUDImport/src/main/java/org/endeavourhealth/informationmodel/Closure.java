package org.endeavourhealth.informationmodel;

public class Closure {
    private String parent;
    private Integer level;

    public String getParent() {
        return parent;
    }

    public Closure setParent(String parent) {
        this.parent = parent;
        return this;
    }

    public Integer getLevel() {
        return level;
    }

    public Closure setLevel(Integer level) {
        this.level = level;
        return this;
    }
}
