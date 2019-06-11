package org.endeavourhealth.im.models;

public class Document {
    private int dbid;
    private String path;
    private Version version;
    private Boolean draft;

    public int getDbid() {
        return dbid;
    }

    public Document setDbid(int dbid) {
        this.dbid = dbid;
        return this;
    }

    public String getPath() {
        return path;
    }

    public Document setPath(String path) {
        this.path = path;
        return this;
    }

    public Version getVersion() {
        return version;
    }

    public Document setVersion(Version version) {
        this.version = version;
        return this;
    }

    public Boolean getDraft() {
        return draft;
    }

    public Document setDraft(Boolean draft) {
        this.draft = draft;
        return this;
    }
}
