package org.endeavourhealth.im.models;

import java.util.Date;

public class CodeableConcept extends Concept {
    private String scheme;
    private String code;
    private Date updated;

    public String getScheme() {
        return scheme;
    }

    public CodeableConcept setScheme(String scheme) {
        this.scheme = scheme;
        return this;
    }

    public String getCode() {
        return code;
    }

    public CodeableConcept setCode(String code) {
        this.code = code;
        return this;
    }

    public Date getUpdated() {
        return updated;
    }

    public CodeableConcept setUpdated(Date updated) {
        this.updated = updated;
        return this;
    }
}
