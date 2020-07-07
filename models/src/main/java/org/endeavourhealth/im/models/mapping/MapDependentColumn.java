package org.endeavourhealth.im.models.mapping;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MapDependentColumn {
    private String column;
    private MapValueRequest value;

    @JsonProperty("Column")
    public String getColumn() {
        return column;
    }

    public MapDependentColumn setColumn(String column) {
        this.column = column;
        return this;
    }

    @JsonProperty("Value")
    public MapValueRequest getValue() {
        return value;
    }

    public MapDependentColumn setValue(MapValueRequest value) {
        this.value = value;
        return this;
    }
}
