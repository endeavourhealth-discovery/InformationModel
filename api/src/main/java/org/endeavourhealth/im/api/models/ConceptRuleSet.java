package org.endeavourhealth.im.api.models;

import org.endeavourhealth.im.common.models.DbEntity;

import java.util.List;

public class ConceptRuleSet extends DbEntity<ConceptRuleSet> {
    private Long conceptId;
    private Long targetId;
    private List<ConceptRule> rules;

    public Long getConceptId() {
        return conceptId;
    }

    public ConceptRuleSet setConceptId(Long conceptId) {
        this.conceptId = conceptId;
        return this;
    }

    public Long getTargetId() {
        return targetId;
    }

    public ConceptRuleSet setTargetId(Long targetId) {
        this.targetId = targetId;
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
