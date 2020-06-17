package org.endeavourhealth.im.models.mapping;

public class Context {
    private Identifier organisation;
    private Identifier system;
    private Identifier schema;
    private Table table;

    public Context() {
    }

    public Context(Identifier organisation, Identifier system, Identifier schema, Table table) {
        this.organisation = organisation;
        this.system = system;
        this.schema = schema;
        this.table = table;
    }

    public Identifier getOrganisation() {
        return organisation;
    }

    public Context setOrganisation(Identifier organisation) {
        this.organisation = organisation;
        return this;
    }

    public Identifier getSystem() {
        return system;
    }

    public Context setSystem(Identifier system) {
        this.system = system;
        return this;
    }

    public Identifier getSchema() {
        return schema;
    }

    public Context setSchema(Identifier schema) {
        this.schema = schema;
        return this;
    }

    public Table getTable() {
        return table;
    }

    public Context setTable(Table table) {
        this.table = table;
        return this;
    }
}
