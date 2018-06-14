package org.endeavourhealth.im.common.models;

public class Relationship extends DbEntity<Relationship> {
    private Long source;
    private Long relationship;
    private Long target;
    private Integer order;
    private Boolean mandatory;
    private Boolean unlimited;
    private Integer weighting;

    public Long getSource() {
        return source;
    }

    public Relationship setSource(Long source) {
        this.source = source;
        return this;
    }

    public Long getRelationship() {
        return relationship;
    }

    public Relationship setRelationship(Long relationship) {
        this.relationship = relationship;
        return this;
    }

    public Long getTarget() {
        return target;
    }

    public Relationship setTarget(Long target) {
        this.target = target;
        return this;
    }

    public Integer getOrder() {
        return order;
    }

    public Relationship setOrder(Integer order) {
        this.order = order;
        return this;
    }

    public Boolean getMandatory() {
        return mandatory;
    }

    public Relationship setMandatory(Boolean mandatory) {
        this.mandatory = mandatory;
        return this;
    }

    public Boolean getUnlimited() {
        return unlimited;
    }

    public Relationship setUnlimited(Boolean unlimited) {
        this.unlimited = unlimited;
        return this;
    }

    public Integer getWeighting() {
        return weighting;
    }

    public Relationship setWeighting(Integer weighting) {
        this.weighting = weighting;
        return this;
    }
}
