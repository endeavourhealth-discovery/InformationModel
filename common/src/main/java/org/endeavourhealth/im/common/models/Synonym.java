package org.endeavourhealth.im.common.models;

public class Synonym extends DbEntity<Synonym> {
    private Long concept;
    private String term;
    private Boolean preferred;
    private ConceptStatus status;

    public Long getConcept() {
        return concept;
    }

    public Synonym setConcept(Long concept) {
        this.concept = concept;
        return this;
    }

    public String getTerm() {
        return term;
    }

    public Synonym setTerm(String term) {
        this.term = term;
        return this;
    }

    public Boolean getPreferred() {
        return preferred;
    }

    public Synonym setPreferred(Boolean preferred) {
        this.preferred = preferred;
        return this;
    }

    public ConceptStatus getStatus() {
        return status;
    }

    public Synonym setStatus(ConceptStatus status) {
        this.status = status;
        return this;
    }
}
