package org.endeavourhealth.im.models;

public class RelatedConcept extends DbEntity<RelatedConcept> {
    private Reference source;
    private Reference target;
    private Reference relationship;
    private Integer order;
    private Boolean mandatory;
    private Integer limit;
    private ConceptStatus status;

    public Reference getSource() {
        return source;
    }

    public RelatedConcept setSource(Reference source) {
        this.source = source;
        return this;
    }

    public Reference getTarget() {
        return target;
    }

    public RelatedConcept setTarget(Reference target) {
        this.target = target;
        return this;
    }

    public Reference getRelationship() {
        return relationship;
    }

    public RelatedConcept setRelationship(Reference relationship) {
        this.relationship = relationship;
        return this;
    }

    public Integer getOrder() {
        return order;
    }

    public RelatedConcept setOrder(Integer order) {
        this.order = order;
        return this;
    }

    public Boolean getMandatory() {
        return mandatory;
    }

    public RelatedConcept setMandatory(Boolean mandatory) {
        this.mandatory = mandatory;
        return this;
    }

    public Integer getLimit() {
        return limit;
    }

    public RelatedConcept setLimit(Integer limit) {
        this.limit = limit;
        return this;
    }

    public ConceptStatus getStatus() {
        return status;
    }

    public RelatedConcept setStatus(ConceptStatus status) {
        this.status = status;
        return this;
    }
}
