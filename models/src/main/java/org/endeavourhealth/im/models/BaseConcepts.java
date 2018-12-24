package org.endeavourhealth.im.models;

import com.fasterxml.jackson.annotation.JsonValue;

public enum BaseConcepts {
    TYPE (1L, "Type"),
    RECORD_TYPE (2L, "Record type"),
    FIELD_TYPE (3L, "Field type"),
    CODE_CONCEPT (4L, "Code concept"),
    CODE_FIELD (5L, "Code field"),
    // 6
    // 7
    NUMERIC_FIELD (8L, "Numeric field"),
    DATE_TIME_FIELD (9L, "Date time field"),
    TEXT_FIELD (10L, "Text field"),
    BOOLEAN_FIELD (11L, "Boolean field"),
    // 12
    // 13
    FOLDER_TYPE (14L, "Folder type"),
    RELATIONSHIP (15L, "Relationship"),


    IS_A (100L, "Is a "),
    RELATED_TO (101L, "Related to"),
    HAS_A (102L, "Has a"),
    HAS_QUALIFIER (103L, "Has qualifier")
    ;

    private final Long value;
    private final String name;
    BaseConcepts(Long value, String name) {
        this.value = value;
        this.name = name;
    }

    @JsonValue
    public Long getValue() { return this.value; }
    public String getName() { return this.name; }
    public String toString() {
        return this.value.toString();
    }

    public static BaseConcepts byValue(Long value) {
        for (BaseConcepts t: BaseConcepts.values()) {
            if (t.value.equals(value))
                return t;
        }

        return null;
    }
}