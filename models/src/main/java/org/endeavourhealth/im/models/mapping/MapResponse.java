package org.endeavourhealth.im.models.mapping;

public class MapResponse {
    private String nodeId;
    private ConceptIdentifiers concept;
    private MapRequest request;

    public String getNodeId() {
        return nodeId;
    }

    public MapResponse setNodeId(String nodeId) {
        this.nodeId = nodeId;
        return this;
    }

    public ConceptIdentifiers getConcept() {
        return concept;
    }

    public MapResponse setConcept(ConceptIdentifiers concept) {
        this.concept = concept;
        return this;
    }

    public MapRequest getRequest() {
        return request;
    }

    public MapResponse setRequest(MapRequest request) {
        this.request = request;
        return this;
    }
}
