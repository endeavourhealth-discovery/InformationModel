package sample;

import java.util.ArrayList;
import java.util.List;

public class MapData {
    private String context;
    private String target;
    private boolean targetIsNode;
    private String codeScheme;
    private List<Value> values = new ArrayList<Value>();

    public String getContext() {
        return context;
    }

    public MapData setContext(String context) {
        this.context = context;
        return this;
    }

    public String getTarget() {
        return target;
    }

    public MapData setTarget(String target) {
        this.target = target;
        return this;
    }

    public boolean targetIsNode() {
        return targetIsNode;
    }

    public MapData setTargetIsNode(boolean targetANode) {
        this.targetIsNode = targetANode;
        return this;
    }

    public String getCodeScheme() {
        return codeScheme;
    }

    public MapData setCodeScheme(String codeScheme) {
        this.codeScheme = codeScheme;
        return this;
    }

    public List<Value> getValues() {
        return values;
    }

    public MapData setValues(List<Value> values) {
        this.values = values;
        return this;
    }

    public void addValue(Value value) {
        if (values == null)
            values = new ArrayList<Value>();

        values.add(value);
    }
}
