import {Injectable} from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Concept} from '../models/Concept';
import {Observable} from 'rxjs';
import {SearchResult} from '../models/SearchResult';
import {ConceptSummary} from '../models/ConceptSummary';

@Injectable()
export class ConceptSelectorService {
    constructor(private http: Http) {}

    getMRU(): Observable<SearchResult> {
        return this.http.get('{information-model}/api/Concept/MRU')
            .map((result) => result.json());
    }

    search(searchTerm: string, includeDeprecated: boolean, schemes: number[], page: number = 1, relatedConcept: number = null, expression: number = 0): Observable<SearchResult> {
        const params = new URLSearchParams();
        params.append('searchTerm', searchTerm);
        if (schemes)
            for(let scheme of schemes)
                params.append('scheme', scheme.toString());
        params.append('includeDeprecated', includeDeprecated.toString());
        params.append('page', page.toString());
        if (relatedConcept!=null)
            params.append('relatedConcept', relatedConcept.toString());
        if (expression!=null)
            params.append('expression', expression.toString())

        return this.http.get('{information-model}/api/Concept/Search', {search: params})
            .map((result) => result.json());
    }

    getConcept(conceptId: number): Observable<Concept> {
        return this.http.get('{information-model}/api/Concept/' + conceptId.toString())
            .map((result) => result.json());
    }

    getSubtypes(conceptId: number, all: boolean = false): Observable<ConceptSummary[]> {
        const params = new URLSearchParams();
        if (all)
            params.append('all', all.toString());

        return this.http.get('api/Concept/' + conceptId.toString() + '/Subtypes', {search: params})
            .map((result) => result.json());
    }
}
