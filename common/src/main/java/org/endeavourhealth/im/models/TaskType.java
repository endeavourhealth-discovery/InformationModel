package org.endeavourhealth.im.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum TaskType {
    ATTRIBUTE_MODEL ((byte)0, "Attribute model"),
    VALUE_MODEL ((byte)1, "Value model"),
    MESSAGE_MAPPINGS ((byte)2, "Message mappings"),
    TERM_MAPPINGS ((byte)3, "Term mappings");

    private final Byte value;
    private final String name;
    TaskType(byte value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public byte getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static TaskType byValue(Byte value) {
        for (TaskType t: TaskType.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}