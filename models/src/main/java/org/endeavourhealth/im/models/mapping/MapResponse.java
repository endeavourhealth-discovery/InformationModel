package org.endeavourhealth.im.models.mapping;

public class MapResponse {
    private MapNodeData nodeData;
    private ConceptIdentifiers concept;
    private MapRequest request;

    public MapNodeData getNodeData() {
        return nodeData;
    }

    public MapResponse setNodeData(MapNodeData nodeData) {
        this.nodeData = nodeData;
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
