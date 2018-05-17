package org.endeavourhealth.im.common.models;

public class DbEntity<T extends DbEntity<T>> {
    private Long id;

    public Long getId() {
        return id;
    }

    public T setId(Long id) {
        this.id = id;
        return (T)this;
    }
}
