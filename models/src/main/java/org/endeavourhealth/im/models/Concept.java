package org.endeavourhealth.im.models;

import java.util.Date;

public class Concept {
    private int dbid;
    private String id;
    private String name;
    private String scheme;
    private String code;
    private Short status;
    private Date updated;

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

    public Short getStatus() {
        return status;
    }

    public Concept setStatus(Short status) {
        this.status = status;
        return this;
    }

    public Date getUpdated() {
        return updated;
    }

    public Concept setUpdated(Date updated) {
        this.updated = updated;
        return this;
    }
}
