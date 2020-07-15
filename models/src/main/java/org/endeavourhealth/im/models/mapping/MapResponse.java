package org.endeavourhealth.im.models.mapping;

public class MapResponse {
    private MapNode node;
    private MapValueNode valueNode;
    private ConceptIdentifiers concept;
    private MapRequest request;

    public MapNode getNode() {
        return node;
    }

    public MapResponse setNode(MapNode node) {
        this.node = node;
        return this;
    }

    public MapValueNode getValueNode() {
        return valueNode;
    }

    public MapResponse setValueNode(MapValueNode valueNode) {
        this.valueNode = valueNode;
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
