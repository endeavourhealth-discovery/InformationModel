package org.endeavourhealth.im.common.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum ConceptRelationship {
      HAS_SUBTYPE               (100L, "Has subtype",              "Relationship.HasSubtype"),
      INHERITS_FIELDS           (101L, "Inherits fields",          "Attribute.InheritsFields"),
      HAS_FIELD                 (102L, "Has field",                "Relationship.HasField"),
      HAS_VALUE_TYPE            (103L, "Has value type",           "Attribute.HasValueType"),
      HAS_PREFERRED_VALUE_SET   (104L, "Has preferred value set",  "Attribute.HasPreferredValueSet"),
      HAS_LINKED_RECORD_TYPE    (105L, "Has linked record type",   "Attribute.HasLinkedRecordType"),
      HAS_LINKED_FIELD          (106L, "Has linked field",         "Attribute.HasLinkedField"),
      IS_LIST                   (107L, "Is list",                  "Attribute.IsList"),
      HAS_CHILD                 (108L, "Has child",                "Relationship.HasChild");

    private final Long id;
    private final String fullName;
    private final String context;

    ConceptRelationship(Long id, String fullName, String context) {
        this.id = id;
        this.fullName = fullName;
        this.context = context;
    }

    @JsonCreator
    public static ConceptRelationship forValue(Integer value) {
        return ConceptRelationship.values()[value - 100];
    }

    @JsonValue
    public Long getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public String getContext() {
        return context;
    }
}
