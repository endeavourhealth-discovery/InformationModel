package org.endeavourhealth.im.common.models;

import java.util.List;

public class ConceptSummaryList {
    private Integer page;
    private Integer count;
    private List<ConceptSummary> concepts;

    public Integer getPage() {
        return page;
    }

    public ConceptSummaryList setPage(Integer page) {
        this.page = page;
        return this;
    }

    public Integer getCount() {
        return count;
    }

    public ConceptSummaryList setCount(Integer count) {
        this.count = count;
        return this;
    }

    public List<ConceptSummary> getConcepts() {
        return concepts;
    }

    public ConceptSummaryList setConcepts(List<ConceptSummary> concepts) {
        this.concepts = concepts;
        return this;
    }
}
