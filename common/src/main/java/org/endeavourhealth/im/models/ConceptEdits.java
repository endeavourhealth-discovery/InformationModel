package org.endeavourhealth.im.models;

import java.util.List;

public class ConceptEdits {
    private List<Attribute> editedAttributes;
    private List<Attribute> deletedAttributes;
    private List<RelatedConcept> editedRelated;
    private List<RelatedConcept> deletedRelated;

    public List<Attribute> getEditedAttributes() {
        return editedAttributes;
    }

    public ConceptEdits setEditedAttributes(List<Attribute> editedAttributes) {
        this.editedAttributes = editedAttributes;
        return this;
    }

    public List<Attribute> getDeletedAttributes() {
        return deletedAttributes;
    }

    public ConceptEdits setDeletedAttributes(List<Attribute> deletedAttributes) {
        this.deletedAttributes = deletedAttributes;
        return this;
    }

    public List<RelatedConcept> getEditedRelated() {
        return editedRelated;
    }

    public ConceptEdits setEditedRelated(List<RelatedConcept> editedRelated) {
        this.editedRelated = editedRelated;
        return this;
    }

    public List<RelatedConcept> getDeletedRelated() {
        return deletedRelated;
    }

    public ConceptEdits setDeletedRelated(List<RelatedConcept> deletedRelated) {
        this.deletedRelated = deletedRelated;
        return this;
    }
}
