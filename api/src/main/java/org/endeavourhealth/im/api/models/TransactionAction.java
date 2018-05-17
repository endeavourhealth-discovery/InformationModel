package org.endeavourhealth.im.api.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum TransactionAction {
    CREATE ((byte)0, "Create"),
    UPDATE ((byte)1, "Update"),
    DELETE ((byte)2, "Delete");

    private final Byte value;
    private final String name;
    TransactionAction(byte value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public byte getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static TransactionAction byValue(Byte value) {
        if (value == null)
            return null;

        for (TransactionAction t: TransactionAction.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}
