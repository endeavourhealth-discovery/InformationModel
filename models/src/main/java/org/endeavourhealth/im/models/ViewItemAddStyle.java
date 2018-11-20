package org.endeavourhealth.im.models;

public enum ViewItemAddStyle {
    CONCEPT_ONLY,
    ATTRIBUTES_ONLY,
    BOTH;

    private static final ViewItemAddStyle[] map = ViewItemAddStyle.values();

    public static ViewItemAddStyle fromInt(int value) {
        return map[value];
    }
}
