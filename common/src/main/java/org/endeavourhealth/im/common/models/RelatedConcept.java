package org.endeavourhealth.im.common.models;

public class RelatedConcept extends DbEntity<RelatedConcept> {
    private Long sourceId;
    private ConceptSummary source;
    private Long targetId;
    private ConceptSummary target;
    private ConceptReference relationship;
    private Integer order;
    private Boolean mandatory;
    private Integer limit;
    private Integer weighting;

    public Long getSourceId() {
        return (source == null) ? sourceId : source.getId();
    }

    public RelatedConcept setSourceId(Long sourceId) {
        this.sourceId = sourceId;

        if (source != null)
            this.source.setId(sourceId);

        return this;
    }

    public ConceptSummary getSource() {
        return source;
    }

    public RelatedConcept setSource(ConceptSummary source) {
        this.source = source;
        return this;
    }

    public Long getTargetId() {
        return targetId;
    }

    public RelatedConcept setTargetId(Long targetId) {
        this.targetId = targetId;
        if (target != null)
            this.target.setId(targetId);
        return this;
    }

    public ConceptSummary getTarget() {
        return target;
    }

    public RelatedConcept setTarget(ConceptSummary target) {
        this.target = target;
        return this;
    }

    public ConceptReference getRelationship() {
        return relationship;
    }

    public RelatedConcept setRelationship(ConceptReference relationship) {
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

    public Integer getWeighting() {
        return weighting;
    }

    public RelatedConcept setWeighting(Integer weighting) {
        this.weighting = weighting;
        return this;
    }
}
