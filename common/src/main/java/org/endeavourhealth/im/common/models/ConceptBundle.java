package org.endeavourhealth.im.common.models;

import java.util.ArrayList;
import java.util.List;

public class ConceptBundle {
    private Concept concept;
//    private List<Attribute> attributes = new ArrayList<>();
    private List<RelatedConcept> related = new ArrayList<>();
    private List<ConceptRuleSet> ruleSets = new ArrayList<>();
//    private List<Long> deletedAttributeIds = new ArrayList<>();
    private List<Long> deletedRelatedIds = new ArrayList<>();
    private List<Long> deletedRuleSetIds = new ArrayList<>();

    public Concept getConcept() {
        return concept;
    }

    public ConceptBundle setConcept(Concept concept) {
        this.concept = concept;
        return this;
    }
//
//    public List<Attribute> getAttributes() {
//        return attributes;
//    }
//
//    public ConceptBundle setAttributes(List<Attribute> attributes) {
//        this.attributes = attributes;
//        return this;
//    }

    public List<RelatedConcept> getRelated() {
        return related;
    }

    public ConceptBundle setRelated(List<RelatedConcept> related) {
        this.related = related;
        return this;
    }

//    public List<Long> getDeletedAttributeIds() {
//        return deletedAttributeIds;
//    }
//
//    public ConceptBundle setDeletedAttributeIds(List<Long> deletedAttributeIds) {
//        this.deletedAttributeIds = deletedAttributeIds;
//        return this;
//    }
//
    public List<Long> getDeletedRelatedIds() {
        return deletedRelatedIds;
    }

    public ConceptBundle setDeletedRelatedIds(List<Long> deletedRelatedIds) {
        this.deletedRelatedIds = deletedRelatedIds;
        return this;
    }

    public List<ConceptRuleSet> getRuleSets() {
        return ruleSets;
    }

    public ConceptBundle setRuleSets(List<ConceptRuleSet> ruleSets) {
        this.ruleSets = ruleSets;
        return this;
    }

    public List<Long> getDeletedRuleSetIds() {
        return deletedRuleSetIds;
    }

    public ConceptBundle setDeletedRuleSetIds(List<Long> deletedRuleSetIds) {
        this.deletedRuleSetIds = deletedRuleSetIds;
        return this;
    }
}
