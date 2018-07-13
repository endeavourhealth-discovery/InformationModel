package org.endeavourhealth.im.common.models;

import java.util.ArrayList;
import java.util.List;

public class CalculationResult {
    private Integer status;
    private List<ConceptReference> stackTrace = new ArrayList<>();
    private Concept result;

    public Integer getStatus() {
        return status;
    }

    public CalculationResult setStatus(Integer status) {
        this.status = status;
        return this;
    }

    public List<ConceptReference> getStackTrace() {
        return stackTrace;
    }

    public CalculationResult setStackTrace(List<ConceptReference> stackTrace) {
        this.stackTrace = stackTrace;
        return this;
    }

    public Concept getResult() {
        return result;
    }

    public CalculationResult setResult(Concept result) {
        this.result = result;
        return this;
    }
}
