package org.endeavourhealth.im.models.mapping;

public class Identifier {
    private String value;
    private String scheme;
    private String display;
    private String _short;

    public Identifier() {
    }

    public Identifier(String value, String scheme) {
        this.value = value;
        this.scheme = scheme;
    }

    public Identifier(String value, String scheme, String display) {
        this.value = value;
        this.scheme = scheme;
        this.display = display;
    }

    public Identifier(String value, String scheme, String display, String _short) {
        this.value = value;
        this.scheme = scheme;
        this.display = display;
        this._short = _short;
    }

    public String getValue() {
        return value;
    }

    public Identifier setValue(String value) {
        this.value = value;
        return this;
    }

    public String getScheme() {
        return scheme;
    }

    public Identifier setScheme(String scheme) {
        this.scheme = scheme;
        return this;
    }

    public String getDisplay() {
        return display;
    }

    public Identifier setDisplay(String display) {
        this.display = display;
        return this;
    }

    public String getShort() {
        return _short;
    }

    public Identifier setShort(String _short) {
        this._short = _short;
        return this;
    }
}
