package org.endeavourhealth.im.models;

public class KVP {
    private Integer key;
    private String value;

    public Integer getKey() {
        return key;
    }

    public KVP setKey(Integer key) {
        this.key = key;
        return this;
    }

    public String getValue() {
        return value;
    }

    public KVP setValue(String value) {
        this.value = value;
        return this;
    }
}
