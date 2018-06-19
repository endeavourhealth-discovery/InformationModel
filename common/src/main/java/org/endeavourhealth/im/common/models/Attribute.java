package org.endeavourhealth.im.common.models;

public class Attribute extends DbEntity<Attribute> {
    private Long conceptId;
    // TODO: private ConceptSummary concept; -- For "Is Attribute of"
    private Long attributeId;
    private ConceptSummary attribute;
    private Integer order;
    private Boolean mandatory;
    private Integer limit;

    public Long getConceptId() {
        return conceptId;
    }

    public Attribute setConceptId(Long conceptId) {
        this.conceptId = conceptId;
        return this;
    }

    public Long getAttributeId() {
        return attributeId;
    }

    public Attribute setAttributeId(Long attributeId) {
        this.attributeId = attributeId;

        if (attribute != null)
            this.attribute.setId(attributeId);

        return this;
    }

    public Integer getOrder() {
        return order;
    }

    public Attribute setOrder(Integer order) {
        this.order = order;
        return this;
    }

    public Boolean getMandatory() {
        return mandatory;
    }

    public Attribute setMandatory(Boolean mandatory) {
        this.mandatory = mandatory;
        return this;
    }

    public Integer getLimit() {
        return limit;
    }

    public Attribute setLimit(Integer limit) {
        this.limit = limit;
        return this;
    }

    public ConceptSummary getAttribute() {
        return attribute;
    }

    public Attribute setAttribute(ConceptSummary attribute) {
        this.attribute = attribute;
        return this;
    }
}
