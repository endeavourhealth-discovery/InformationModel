package org.endeavourhealth.im.models;

import java.util.Date;

public class Task extends DbEntity<Task> {
    private TaskType type;
    private String name;
    private String description;
    private Date created;
    private Long identifier;

    public TaskType getType() {
        return type;
    }

    public Task setType(TaskType type) {
        this.type = type;
        return this;
    }

    public String getName() {
        return name;
    }

    public Task setName(String name) {
        this.name = name;
        return this;
    }

    public String getDescription() {
        return description;
    }

    public Task setDescription(String description) {
        this.description = description;
        return this;
    }

    public Date getCreated() {
        return created;
    }

    public Task setCreated(Date created) {
        this.created = new Date(created.getTime());
        return this;
    }

    public Long getIdentifier() {
        return identifier;
    }

    public Task setIdentifier(Long identifier) {
        this.identifier = identifier;
        return this;
    }
}
