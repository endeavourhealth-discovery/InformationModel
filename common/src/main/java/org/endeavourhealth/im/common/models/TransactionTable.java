package org.endeavourhealth.im.common.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum TransactionTable {
    CONCEPT ((byte)0, "Concept"),
    TASK ((byte)1, "Task"),
    TERM_MAPPING((byte)2, "Term Mapping"),
    RELATIONSHIP((byte)3, "Relationship");

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
