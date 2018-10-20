package org.endeavourhealth.im.models;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.Date;

@ApiModel(value = "Information model concept")
public class Concept extends DbEntity<Concept> {
    private Reference superclass;
    private String url;
    private String fullName;
    private String shortName;
    private String context;
    private ConceptStatus status;
    private Float version;
    private String description;
    private Long useCount;
    private Date lastUpdate;

    public Reference getSuperclass() {
        return superclass;
    }

    public Concept setSuperclass(Reference superclass) {
        this.superclass = superclass;
        return this;
    }

    public String getUrl() {
        return url;
    }

    public Concept setUrl(String url) {
        this.url = url;
        return this;
    }

    public String getFullName() {
        return fullName;
    }

    public Concept setFullName(String fullName) {
        this.fullName = fullName;
        return this;
    }

    public String getShortName() {
        return shortName;
    }

    public Concept setShortName(String shortName) {
        this.shortName = shortName;
        return this;
    }

    public String getContext() {
        return context;
    }

    public Concept setContext(String context) {
        this.context = context;
        return this;
    }

    @ApiModelProperty(value = "Status of the concept", allowableValues = "0 = Draft, 1 = Active, 2 = Deprecated, 3 = Temporary")
    public ConceptStatus getStatus() {
        return status;
    }

    public Concept setStatus(ConceptStatus status) {
        this.status = status;
        return this;
    }

    public Float getVersion() {
        return version;
    }

    public Concept setVersion(Float version) {
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

    public void incUseCount() {
        this.useCount++;
    }

    public Date getLastUpdate() {
        return lastUpdate;
    }

    public Concept setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
        return this;
    }
}
