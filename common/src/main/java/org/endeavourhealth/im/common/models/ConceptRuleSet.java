package org.endeavourhealth.im.common.models;

import java.util.List;

public class ConceptRuleSet extends DbEntity<ConceptRuleSet> {
    private Long conceptId;
    private ConceptReference target;
    private String resourceType;
    private Integer order;
    private List<ConceptRule> rules;

    public Long getConceptId() {
        return conceptId;
    }

    public ConceptRuleSet setConceptId(Long conceptId) {
        this.conceptId = conceptId;
        return this;
    }

    public ConceptReference getTarget() {
        return target;
    }

    public ConceptRuleSet setTarget(ConceptReference target) {
        this.target = target;
        return this;
    }

    public String getResourceType() {
        return resourceType;
    }

    public ConceptRuleSet setResourceType(String resourceType) {
        this.resourceType = resourceType;
        return this;
    }

    public Integer getOrder() {
        return order;
    }

    public ConceptRuleSet setOrder(Integer order) {
        this.order = order;
        return this;
    }

    public List<ConceptRule> getRules() {
        return rules;
    }

    public ConceptRuleSet setRules(List<ConceptRule> rules) {
        this.rules = rules;
        return this;
    }
}
