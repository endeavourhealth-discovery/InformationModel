package org.endeavourhealth.im.models.mapping;

public class MapNode {
    private int nodeId;
    private String node;

    public MapNode(int nodeId, String node) {
        this.nodeId = nodeId;
        this.node = node;
    }

    public int getNodeId() {
        return nodeId;
    }

    public MapNode setNodeId(int nodeId) {
        this.nodeId = nodeId;
        return this;
    }

    public String getNode() {
        return node;
    }

    public MapNode setNode(String node) {
        this.node = node;
        return this;
    }
}
