package org.endeavourhealth.im.common.models;

public class Concept extends DbEntity<Concept> {
    private String url;
    private Long type;
    private String fullName;
    private String context;
    private ConceptStatus status;
    private String version;
    private String description;
    private Long useCount;
    private Boolean autoTemplate = true;
    private String template;

    public String getUrl() {
        return url;
    }

    public Concept setUrl(String url) {
        this.url = url;
        return this;
    }

    public Long getType() {
        return type;
    }

    public Concept setType(Long type) {
        this.type = type;
        return this;
    }

    public String getFullName() {
        return fullName;
    }

    public Concept setFullName(String fullName) {
        this.fullName = fullName;
        return this;
    }

    public String getContext() {
        return context;
    }

    public Concept setContext(String context) {
        this.context = context;
        return this;
    }

    public ConceptStatus getStatus() {
        return status;
    }

    public Concept setStatus(ConceptStatus status) {
        this.status = status;
        return this;
    }

    public String getVersion() {
        return version;
    }

    public Concept setVersion(String version) {
        this.version = version;
        return this;
    }

    public String getDescription() {
        return description;
    }

    public Concept setDescription(String description) {
        this.description = description;
        return this;
    }

    public Long getUseCount() {
        return useCount;
    }

    public Concept setUseCount(Long useCount) {
        this.useCount = useCount;
        return this;
    }

    public Boolean getAutoTemplate() {
        return autoTemplate;
    }

    public Concept setAutoTemplate(Boolean autoTemplate) {
        this.autoTemplate = autoTemplate;
        return this;
    }

    public String getTemplate() {
        return template;
    }

    public Concept setTemplate(String template) {
        this.template = template;
        return this;
    }
}
