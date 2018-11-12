package org.endeavourhealth.im.models;

public class Attribute extends DbEntity<Attribute> {
    private Reference concept;
    private Reference attribute;
    private Integer order;
    private Boolean mandatory;
    private Integer limit;
    private Byte inheritance;
    private Reference valueConcept;
    private ValueExpression valueExpression;
    private Reference fixedConcept;
    private String fixedValue;
    private ConceptStatus status;

    public Reference getConcept() {
        return concept;
    }

    public Attribute setConcept(Reference concept) {
        this.concept = concept;
        return this;
    }

    public Reference getAttribute() {
        return attribute;
    }

    public Attribute setAttribute(Reference attribute) {
        this.attribute = attribute;
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

    public Byte getInheritance() {
        return inheritance;
    }

    public Attribute setInheritance(Byte inheritance) {
        this.inheritance = inheritance;
        return this;
    }

    public Reference getValueConcept() {
        return valueConcept;
    }

    public Attribute setValueConcept(Reference valueConcept) {
        this.valueConcept = valueConcept;
        return this;
    }

    public ValueExpression getValueExpression() {
        return valueExpression;
    }

    public Attribute setValueExpression(ValueExpression valueExpression) {
        this.valueExpression = valueExpression;
        return this;
    }

    public Reference getFixedConcept() {
        return fixedConcept;
    }

    public Attribute setFixedConcept(Reference fixedConcept) {
        this.fixedConcept = fixedConcept;
        return this;
    }

    public String getFixedValue() {
        return fixedValue;
    }

    public Attribute setFixedValue(String fixedValue) {
        this.fixedValue = fixedValue;
        return this;
    }

    public ConceptStatus getStatus() {
        return status;
    }

    public Attribute setStatus(ConceptStatus status) {
        this.status = status;
        return this;
    }
}
