package org.endeavourhealth.im.models.mapping;

public class MapValueNode {
    int id;
    String codeScheme;
    String function;

    public MapValueNode(int id, String codeScheme, String function) {
        this.id = id;
        this.codeScheme = codeScheme;
        this.function = function;
    }

    public int getId() {
        return id;
    }

    public MapValueNode setId(int id) {
        this.id = id;
        return this;
    }

    public String getCodeScheme() {
        return codeScheme;
    }

    public MapValueNode setCodeScheme(String codeScheme) {
        this.codeScheme = codeScheme;
        return this;
    }

    public String getFunction() {
        return function;
    }

    public MapValueNode setFunction(String function) {
        this.function = function;
        return this;
    }
}
