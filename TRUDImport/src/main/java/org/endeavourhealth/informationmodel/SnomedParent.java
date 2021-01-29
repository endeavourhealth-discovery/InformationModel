package org.endeavourhealth.informationmodel;

public class SnomedParent {
    private Integer dbid;
    private String conceptId;
    private int group = 0;

    public Integer getDbid() {
        return dbid;
    }

    public SnomedParent setDbid(Integer dbid) {
        this.dbid = dbid;
        return this;
    }

    public SnomedParent(String conceptId, int group) {
        this.conceptId = conceptId;
        this.group = group;
    }

    public String getConceptId() {
        return conceptId;
    }

    public SnomedParent setConceptId(String conceptId) {
        this.conceptId = conceptId;
        return this;
    }

    public int getGroup() {
        return group;
    }

    public SnomedParent setGroup(int group) {
        this.group = group;
        return this;
    }
}
