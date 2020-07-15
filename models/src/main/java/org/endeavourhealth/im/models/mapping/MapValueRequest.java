package org.endeavourhealth.im.models.mapping;

import com.fasterxml.jackson.annotation.JsonProperty;

public class MapValueRequest {
    private String scheme;
    private String code;
    private String term;

    public MapValueRequest() {}

    public MapValueRequest(String scheme, String code) {
        this.scheme = scheme;
        this.code = code;
    }

    public MapValueRequest(String term) {
        this.term = term;
    }

    @JsonProperty("CodeScheme")
    public String getScheme() {
        return scheme;
    }

    public MapValueRequest setScheme(String scheme) {
        this.scheme = scheme;
        return this;
    }

    @JsonProperty("Value")
    public String getCode() {
        return code;
    }

    public MapValueRequest setCode(String code) {
        this.code = code;
        return this;
    }

    @JsonProperty("Term")
    public String getTerm() {
        return term;
    }

    public MapValueRequest setTerm(String term) {
        this.term = term;
        return this;
    }
}
