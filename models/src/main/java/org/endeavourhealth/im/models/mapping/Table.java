package org.endeavourhealth.im.models.mapping;

public class Table {
    private String name;
    private String _short;

    public Table() {}

    public Table(String name) {
        this.name = name;
    }

    public Table(String name, String _short) {
        this.name = name;
        this._short = _short;
    }

    public String getName() {
        return name;
    }

    public Table setName(String name) {
        this.name = name;
        return this;
    }

    public String getShort() {
        return _short;
    }

    public Table setShort(String _short) {
        this._short = _short;
        return this;
    }
}
