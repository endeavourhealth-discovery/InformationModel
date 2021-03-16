package org.endeavourhealth.im.models.mapping;

public class MapNode {
    private int nodeId;
    private String node;
    private String target;

    public MapNode() {
    }

    public MapNode(int nodeId, String node, String target) {
        this.nodeId = nodeId;
        this.node = node;
        this.target = target;
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

    public String getTarget() {
        return target;
    }

    public MapNode setTarget(String target) {
        this.target = target;
        return this;
    }
}
