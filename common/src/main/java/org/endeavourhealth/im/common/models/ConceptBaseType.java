package org.endeavourhealth.im.common.models;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum ConceptBaseType {
      CLASS             (1L,  "Class",             "Concept.Class"),
      RECORD_TYPE       (2L,  "Record type",       "Class.RecordType"),
      EVENT_TYPE        (3L,  "Event type",        "Class.EventType"),
      ATTRIBUTE_GROUP   (4L,  "Attribute group",   "Class.AttributeGroup"),
      NUMERIC           (5L,  "Numeric",           "Class.Numeric"),
      DATE_TIME         (6L,  "DateTime",          "Class.DateTime"),
      CODE              (7L,  "Code",              "Class.Code"),
      TEXT              (8L,  "Text",              "Class.Text"),
      BOOLEAN           (9L,  "Boolean",           "Class.Boolean"),
      CODEABLE_CONCEPT  (10L, "Codeable concept",  "Class.CodeableConcept"),
      FOLDER            (11L, "Folder",            "Class.Folder"),
      RELATIONSHIP      (12L, "Relationship",      "Class.Relationship"),
      FIELD             (13L, "Field",             "Class.Field"),
      FIELD_LIBRARY     (14L, "Field library",     "Class.FieldLibrary"),
      ATTRIBUTE         (15L, "Attribute",         "Class.Attribute"),
      VIEW              (16L, "View",              "Class.View"),
      EXPRESSION        (17L, "Expression",        "Class.Expression"),
      TERM              (18L, "Term",              "Class.Term"),
      LINKED_RECORD     (19L, "Linked record",     "Class.LinkedRecord"),
      LINKED_FIELD      (20L, "Linked field",      "Class.LinkedField");

    private final Long id;
    private final String fullName;
    private final String context;

    ConceptBaseType(Long id, String fullName, String context) {
        this.id = id;
        this.fullName = fullName;
        this.context = context;
    }


    @JsonCreator
    public static ConceptBaseType forValue(Integer value) {
        return ConceptBaseType.values()[value - 1];
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
