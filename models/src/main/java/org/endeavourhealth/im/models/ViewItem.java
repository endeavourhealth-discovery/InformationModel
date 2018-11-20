package org.endeavourhealth.im.models;

public class ViewItem extends DbEntity<ViewItem> {
    private Long conceptId;
    private String conceptName;
    private Long parentId;
    private Long contextId;
    private String contextName;

    public Long getConceptId() {
        return conceptId;
    }

    public ViewItem setConceptId(Long conceptId) {
        this.conceptId = conceptId;
        return this;
    }

    public String getConceptName() {
        return conceptName;
    }

    public ViewItem setConceptName(String conceptName) {
        this.conceptName = conceptName;
        return this;
    }

    public Long getParentId() {
        return parentId;
    }

    public ViewItem setParentId(Long parentId) {
        this.parentId = parentId;
        return this;
    }

    public Long getContextId() {
        return contextId;
    }

    public ViewItem setContextId(Long contextId) {
        this.contextId = contextId;
        return this;
    }

    public String getContextName() {
        return contextName;
    }

    public ViewItem setContextName(String contextName) {
        this.contextName = contextName;
        return this;
    }
}
