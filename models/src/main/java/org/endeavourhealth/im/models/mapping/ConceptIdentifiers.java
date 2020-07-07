package org.endeavourhealth.im.models.mapping;

public class ConceptIdentifiers {
    private Integer dbid;
    private String iri;
    private String code;
    private String scheme;

    public Integer getDbid() {
        return dbid;
    }

    public ConceptIdentifiers setDbid(Integer dbid) {
        this.dbid = dbid;
        return this;
    }

    public String getIri() {
        return iri;
    }

    public ConceptIdentifiers setIri(String iri) {
        this.iri = iri;
        return this;
    }

    public String getCode() {
        return code;
    }

    public ConceptIdentifiers setCode(String code) {
        this.code = code;
        return this;
    }

    public String getScheme() {
        return scheme;
    }

    public ConceptIdentifiers setScheme(String scheme) {
        this.scheme = scheme;
        return this;
    }
}
