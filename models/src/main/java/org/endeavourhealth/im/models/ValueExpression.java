package org.endeavourhealth.im.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum ValueExpression {
    OF_TYPE ((byte)0, "Of type"),
    CHILD_OF ((byte)1, "Child of")
    ;

    private final Byte value;
    private final String name;
    ValueExpression(Byte value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public Byte getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static ValueExpression byValue(Byte value) {
        for (ValueExpression t: ValueExpression.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}
