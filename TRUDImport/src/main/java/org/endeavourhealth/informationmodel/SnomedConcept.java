package org.endeavourhealth.informationmodel;

import java.util.ArrayList;
import java.util.List;

public class SnomedConcept {
    private Integer dbid;
    private String conceptId;
    private String term;
    private Boolean active;
    private List<SnomedParent> parents = new ArrayList<>();
    private List<SnomedParent> deletedParents = new ArrayList<>();

    public Integer getDbid() {
        return dbid;
    }

    public SnomedConcept setDbid(Integer dbid) {
        this.dbid = dbid;
        return this;
    }

    public String getConceptId() {
        return conceptId;
    }

    public SnomedConcept setConceptId(String conceptId) {
        this.conceptId = conceptId;
        return this;
    }

    public String getTerm() {
        return term;
    }

    public SnomedConcept setTerm(String term) {
        this.term = term;
        return this;
    }

    public Boolean getActive() {
        return active;
    }

    public SnomedConcept setActive(Boolean active) {
        this.active = active;
        return this;
    }

    public List<SnomedParent> getParents() {
        return parents;
    }

    public SnomedConcept setParents(List<SnomedParent> parents) {
        this.parents = parents;
        return this;
    }

    public SnomedConcept addParent(SnomedParent parent) {
        this.parents.add(parent);
        return this;
    }

    public List<SnomedParent> getDeletedParents() {
        return deletedParents;
    }

    public SnomedConcept setDeletedParents(List<SnomedParent> deletedParents) {
        this.deletedParents = deletedParents;
        return this;
    }

    public SnomedConcept addDeletedParent(SnomedParent parent) {
        this.deletedParents.add(parent);
        return this;
    }
}
