package org.endeavourhealth.im.models.mapping;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MapColumnRequest {
    private String provider;
    private String system;
    private String schema;
    private String table;
    private String column;

    private String target;

    public MapColumnRequest() {}

    public MapColumnRequest(String provider, String system, String schema, String table, String column) {
        this.provider = provider;
        this.system = system;
        this.schema = schema;
        this.table = table;
        this.column = column;
    }

    @JsonProperty("Provider")
    public String getProvider() {
        return provider;
    }

    public MapColumnRequest setProvider(String provider) {
        this.provider = provider;
        return this;
    }

    @JsonProperty("System")
    public String getSystem() {
        return system;
    }

    public MapColumnRequest setSystem(String system) {
        this.system = system;
        return this;
    }

    @JsonProperty("Schema")
    public String getSchema() {
        return schema;
    }

    public MapColumnRequest setSchema(String schema) {
        this.schema = schema;
        return this;
    }

    @JsonProperty("Table")
    public String getTable() {
        return table;
    }

    public MapColumnRequest setTable(String table) {
        this.table = table;
        return this;
    }

    @JsonProperty("Column")
    public String getColumn() {
        return column;
    }

    public MapColumnRequest setColumn(String column) {
        this.column = column;
        return this;
    }

    @JsonProperty("Target")
    public String getTarget() {
        return target;
    }

    public MapColumnRequest setTarget(String target) {
        this.target = target;
        return this;
    }
}
