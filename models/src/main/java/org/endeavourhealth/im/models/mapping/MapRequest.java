package org.endeavourhealth.im.models.mapping;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MapRequest {
    private MapColumnRequest mapColumnRequest;
    private MapColumnValueRequest mapColumnValueRequest;

    @JsonProperty("MapColumnRequest")
    public MapColumnRequest getMapColumnRequest() {
        return mapColumnRequest;
    }

    public MapRequest setMapColumnRequest(MapColumnRequest mapColumnRequest) {
        this.mapColumnRequest = mapColumnRequest;
        return this;
    }

    @JsonProperty("MapColumnValueRequest")
    public MapColumnValueRequest getMapColumnValueRequest() {
        return mapColumnValueRequest;
    }

    public MapRequest setMapColumnValueRequest(MapColumnValueRequest mapColumnValueRequest) {
        this.mapColumnValueRequest = mapColumnValueRequest;
        return this;
    }
}
