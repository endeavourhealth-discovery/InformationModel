package org.endeavourhealth.im.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum CodeScheme {
    SNOMED (5301L, "SNOMED CT")
    ;

    private final Long value;
    private final String name;
    CodeScheme(Long value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public Long getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static CodeScheme byValue(Byte value) {
        for (CodeScheme t: CodeScheme.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}
