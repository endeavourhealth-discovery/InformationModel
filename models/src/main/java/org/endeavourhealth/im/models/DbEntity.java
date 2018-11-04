package org.endeavourhealth.im.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

public class DbEntity<T extends DbEntity<T>> {
    private Long id;

    public Long getId() {
        return id;
    }

    public T setId(Long id) {
        this.id = id;
        return (T)this;
    }

    @JsonIgnore
    public boolean isNew() {
        return this.id == null;
    }
}
