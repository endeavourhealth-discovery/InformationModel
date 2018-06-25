package org.endeavourhealth.im.api.models;

import org.endeavourhealth.im.common.models.DbEntity;

public class TermMapping extends DbEntity<TermMapping> {
    private String organisation;
    private String context;
    private String system;
    private String code;
    private Long conceptId;

    public String getOrganisation() {
        return organisation;
    }

    public TermMapping setOrganisation(String organisation) {
        this.organisation = organisation;
        return this;
    }

    public String getContext() {
        return context;
    }

    public TermMapping setContext(String context) {
        this.context = context;
        return this;
    }

    public String getSystem() {
        return system;
    }

    public TermMapping setSystem(String system) {
        this.system = system;
        return this;
    }

    public String getCode() {
        return code;
    }

    public TermMapping setCode(String code) {
        this.code = code;
        return this;
    }

    public Long getConceptId() {
        return conceptId;
    }

    public TermMapping setConceptId(Long conceptId) {
        this.conceptId = conceptId;
        return this;
    }
}
