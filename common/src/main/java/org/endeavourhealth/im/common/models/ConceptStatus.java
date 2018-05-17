package org.endeavourhealth.im.common.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum ConceptStatus {
    DRAFT ((byte)0, "Draft"),
    ACTIVE ((byte)1, "Active"),
    DEPRECATED ((byte)2, "Deprecated"),
    TEMPORARY ((byte)3, "Temporary");

    private final Byte value;
    private final String name;
    ConceptStatus(byte value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public byte getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static ConceptStatus byValue(Byte value) {
        for (ConceptStatus t: ConceptStatus.values()) {
            if (t.value == value)
                return t;
        }

        return null;
    }
}