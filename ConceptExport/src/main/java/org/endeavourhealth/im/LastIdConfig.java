package org.endeavourhealth.im;

public class LastIdConfig {
    private int concept;
    private int cpo;
    private int cpd;

    public int getConcept() {
        return concept;
    }

    public LastIdConfig setConcept(int concept) {
        this.concept = concept;
        return this;
    }

    public int getCpo() {
        return cpo;
    }

    public LastIdConfig setCpo(int cpo) {
        this.cpo = cpo;
        return this;
    }

    public int getCpd() {
        return cpd;
    }

    public LastIdConfig setCpd(int cpd) {
        this.cpd = cpd;
        return this;
    }
}
