package org.endeavourhealth.im.models;

public class Attribute extends DbEntity<Attribute> {
    private Reference concept;
    private Reference attribute;
    private Reference type;
//    private AttributeValue value;
    private Integer minimum;
    private Integer maximum;
    private Boolean isConstraint;
    private Reference valueConcept;
    private ValueExpression valueExpression;
    private Reference fixedConcept;
    private String fixedValue;

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

    public Reference getType() {
        return type;
    }

    public Attribute setType(Reference type) {
        this.type = type;
        return this;
    }

//    public AttributeValue getValue() {
//        return value;
//    }
//
//    public Attribute setValue(AttributeValue value) {
//        this.value = value;
//        return this;
//    }

    public Integer getMinimum() {
        return minimum;
    }

    public Attribute setMinimum(Integer minimum) {
        this.minimum = minimum;
        return this;
    }

    public Integer getMaximum() {
        return maximum;
    }

    public Attribute setMaximum(Integer maximum) {
        this.maximum = maximum;
        return this;
    }

    public Boolean getConstraint() {
        return isConstraint;
    }

    public Attribute setConstraint(Boolean constraint) {
        isConstraint = constraint;
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
}
