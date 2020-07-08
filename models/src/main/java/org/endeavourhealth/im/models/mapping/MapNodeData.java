package org.endeavourhealth.im.models.mapping;

public class MapNodeData {
    private int nodeId;
    private String node;
    private MapValueNode valueNode;

    public MapNodeData(int nodeId, String node) {
        this.nodeId = nodeId;
        this.node = node;
    }

    public MapNodeData(int nodeId, String node, MapValueNode valueNode) {
        this.nodeId = nodeId;
        this.node = node;
        this.valueNode = valueNode;
    }

    public int getNodeId() {
        return nodeId;
    }

    public MapNodeData setNodeId(int nodeId) {
        this.nodeId = nodeId;
        return this;
    }

    public String getNode() {
        return node;
    }

    public MapNodeData setNode(String node) {
        this.node = node;
        return this;
    }

    public MapValueNode getValueNode() {
        return valueNode;
    }

    public MapNodeData setValueNode(MapValueNode valueNode) {
        this.valueNode = valueNode;
        return this;
    }
}
