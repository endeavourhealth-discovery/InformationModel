package org.endeavourhealth.im.models;

public class Concept {
    private int dbid;
    private String id;
    private String name;
    private Short status;

    public int getDbid() {
        return dbid;
    }

    public Concept setDbid(int dbid) {
        this.dbid = dbid;
        return this;
    }

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

    public Short getStatus() {
        return status;
    }

    public Concept setStatus(Short status) {
        this.status = status;
        return this;
    }
}
