package org.endeavourhealth.im.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum CodeScheme {
    SNOMED (5301L, "SNOMED CT"),
    READV2 (5302L, "READ 2"),
    READV3 (5303L, "CTV3"),
    OPCS   (5304L, "OPCS"),
    ICD10  (5305L, "ICD10")
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

    public static CodeScheme byValue(Long value) {
        for (CodeScheme t: CodeScheme.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}
