package org.endeavourhealth.im.models.mapping;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class MapColumnValueRequest {
    private String node;
    private String provider;
    private String system;
    private String schema;
    private String table;
    private String column;
    private MapValueRequest value;
    private List<MapDependentColumn> dependentColumnValue;
    private String target;

    @JsonProperty("Node")
    public String getNode() {
        return node;
    }

    public MapColumnValueRequest setNode(String node) {
        this.node = node;
        return this;
    }

    @JsonProperty("Provider")
    public String getProvider() {
        return provider;
    }

    public MapColumnValueRequest setProvider(String provider) {
        this.provider = provider;
        return this;
    }

    @JsonProperty("System")
    public String getSystem() {
        return system;
    }

    public MapColumnValueRequest setSystem(String system) {
        this.system = system;
        return this;
    }

    @JsonProperty("Schema")
    public String getSchema() {
        return schema;
    }

    public MapColumnValueRequest setSchema(String schema) {
        this.schema = schema;
        return this;
    }

    @JsonProperty("Table")
    public String getTable() {
        return table;
    }

    public MapColumnValueRequest setTable(String table) {
        this.table = table;
        return this;
    }

    @JsonProperty("Column")
    public String getColumn() {
        return column;
    }

    public MapColumnValueRequest setColumn(String column) {
        this.column = column;
        return this;
    }

    @JsonProperty("DependentColumnValue")
    public List<MapDependentColumn> getDependentColumnValue() {
        return dependentColumnValue;
    }

    public MapColumnValueRequest setDependentColumnValue(List<MapDependentColumn> dependentColumnValue) {
        this.dependentColumnValue = dependentColumnValue;
        return this;
    }

    @JsonProperty("Value")
    public MapValueRequest getValue() {
        return value;
    }

    public MapColumnValueRequest setValue(MapValueRequest value) {
        this.value = value;
        return this;
    }

    @JsonProperty("Target")
    public String getTarget() {
        return target;
    }

    public MapColumnValueRequest setTarget(String target) {
        this.target = target;
        return this;
    }
}
