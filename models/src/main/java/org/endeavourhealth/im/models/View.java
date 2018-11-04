package org.endeavourhealth.im.models;

import java.util.Date;

public class View extends DbEntity<View> {
    private String name;
    private String description;
    private Date lastUpdated;

    public String getName() {
        return name;
    }

    public View setName(String name) {
        this.name = name;
        return this;
    }

    public String getDescription() {
        return description;
    }

    public View setDescription(String description) {
        this.description = description;
        return this;
    }

    public Date getLastUpdated() {
        return lastUpdated;
    }

    public View setLastUpdated(Date lastUpdated) {
        this.lastUpdated = lastUpdated;
        return this;
    }
}
