package org.endeavourhealth.im.common.models;

public class AttributeModel extends DbEntity<AttributeModel> {
    private String url;
    private String fullName;
    private String context;
    private ConceptStatus status;
    private String version;
    private String description;
    private String expression;
    private String criteria;
    private ConceptReference inherits;

    public String getUrl() {
        return url;
    }

    public AttributeModel setUrl(String url) {
        this.url = url;
        return this;
    }

    public String getFullName() {
        return fullName;
    }

    public AttributeModel setFullName(String fullName) {
        this.fullName = fullName;
        return this;
    }

    public String getContext() {
        return context;
    }

    public AttributeModel setContext(String context) {
        this.context = context;
        return this;
    }

    public ConceptStatus getStatus() {
        return status;
    }

    public AttributeModel setStatus(ConceptStatus status) {
        this.status = status;
        return this;
    }

    public String getVersion() {
        return version;
    }

    public AttributeModel setVersion(String version) {
        this.version = version;
        return this;
    }

    public String getDescription() {
        return description;
    }

    public AttributeModel setDescription(String description) {
        this.description = description;
        return this;
    }

    public String getExpression() {
        return expression;
    }

    public AttributeModel setExpression(String expression) {
        this.expression = expression;
        return this;
    }

    public String getCriteria() {
        return criteria;
    }

    public AttributeModel setCriteria(String criteria) {
        this.criteria = criteria;
        return this;
    }

    public ConceptReference getInherits() {
        return inherits;
    }

    public AttributeModel setInherits(ConceptReference inherits) {
        this.inherits = inherits;
        return this;
    }
}
