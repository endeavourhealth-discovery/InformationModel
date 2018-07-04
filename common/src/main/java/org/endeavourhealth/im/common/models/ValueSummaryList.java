package org.endeavourhealth.im.common.models;

import java.util.List;

public class ValueSummaryList {
    private Integer page;
    private Integer count;
    private List<ValueSummary> conceptValues;

    public Integer getPage() {
        return page;
    }

    public ValueSummaryList setPage(Integer page) {
        this.page = page;
        return this;
    }

    public Integer getCount() {
        return count;
    }

    public ValueSummaryList setCount(Integer count) {
        this.count = count;
        return this;
    }

    public List<ValueSummary> getConceptValues() {
        return conceptValues;
    }

    public ValueSummaryList setConceptValues(List<ValueSummary> conceptValues) {
        this.conceptValues = conceptValues;
        return this;
    }
}
