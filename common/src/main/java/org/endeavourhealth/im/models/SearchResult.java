package org.endeavourhealth.im.models;

import java.util.List;

public class SearchResult {
    private Integer count;
    private Integer page;
    private List<ConceptSummary> results;

    public Integer getCount() {
        return count;
    }

    public SearchResult setCount(Integer count) {
        this.count = count;
        return this;
    }

    public Integer getPage() {
        return page;
    }

    public SearchResult setPage(Integer page) {
        this.page = page;
        return this;
    }

    public List<ConceptSummary> getResults() {
        return results;
    }

    public SearchResult setResults(List<ConceptSummary> results) {
        this.results = results;
        return this;
    }
}
