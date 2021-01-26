package org.endeavourhealth.informationmodel;

import java.util.ArrayList;
import java.util.List;

public class SnomedConcept {
    private String conceptId;
    private String term;
    private Boolean active;
    private List<SnomedParent> parents = new ArrayList<>();

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
}
