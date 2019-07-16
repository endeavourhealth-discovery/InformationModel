package org.endeavourhealth.im.models;

import java.util.ArrayList;
import java.util.List;

public class SearchResult {
    private int page = 1;
    private int count = 0;
    private List<CodeableConcept> results = new ArrayList<>();

    public int getPage() {
        return page;
    }

    public SearchResult setPage(int page) {
        this.page = page;
        return this;
    }

    public int getCount() {
        return count;
    }

    public SearchResult setCount(int count) {
        this.count = count;
        return this;
    }

    public List<CodeableConcept> getResults() {
        return results;
    }

    public SearchResult setResults(List<CodeableConcept> results) {
        this.results = results;
        return this;
    }
}
