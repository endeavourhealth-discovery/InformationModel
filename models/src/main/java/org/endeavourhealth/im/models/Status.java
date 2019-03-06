package org.endeavourhealth.im.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum Status {
    DRAFT ((byte)0, "Draft"),
    INCOMPLETE ((byte)1, "Active"),
    ACTIVE ((byte)2, "Active"),
    DEPRECATED ((byte)3, "Deprecated");

    private final Byte value;
    private final String name;
    Status(byte value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public byte getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static Status byValue(Byte value) {
        for (Status t: Status.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}
