package org.endeavourhealth.im.models;

public class SchemaMapping extends DbEntity<SchemaMapping> {
    private Reference attribute;
    private String table;
    private String field;

    public Reference getAttribute() {
        return attribute;
    }

    public SchemaMapping setAttribute(Reference attribute) {
        this.attribute = attribute;
        return this;
    }

    public String getTable() {
        return table;
    }

    public SchemaMapping setTable(String table) {
        this.table = table;
        return this;
    }

    public String getField() {
        return field;
    }

    public SchemaMapping setField(String field) {
        this.field = field;
        return this;
    }
}
