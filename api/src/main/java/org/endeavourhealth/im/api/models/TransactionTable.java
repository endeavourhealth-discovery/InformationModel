package org.endeavourhealth.im.api.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum TransactionTable {
    CONCEPT ((byte)0, "Concept"),
    MESSAGE ((byte)1, "Message"),
    TASK ((byte)2, "Task"),
    ATTRIBUTE_MODEL((byte)3, "Attribute Model" ),
    TERM_MAPPING((byte)4, "Term Mapping");

    private final Byte value;
    private final String name;
    TransactionTable(byte value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public byte getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static TransactionTable byValue(Byte value) {
        if (value == null)
            return null;

        for (TransactionTable t: TransactionTable.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}
