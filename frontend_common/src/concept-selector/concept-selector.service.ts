import {Injectable} from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Concept} from '../models/Concept';
import {Observable} from 'rxjs';
import {SearchResult} from '../models/SearchResult';

@Injectable()
export class ConceptSelectorService {
    constructor(private http: Http) {}

    search(searchTerm: string, includeDeprecated: boolean, superclass: number = null): Observable<SearchResult> {
        const params = new URLSearchParams();
        params.append('searchTerm', searchTerm.toString());
        params.append('includeDeprecated', includeDeprecated.toString());
        if (superclass)
            params.append('superclass', superclass.toString());

        return this.http.get('{information-model}/api/Concept/Search', {search: params})
            .map((result) => result.json());
    }

    getConcept(conceptId: number): Observable<Concept> {
        const params = new URLSearchParams();
        params.append('id', conceptId.toString());

        return this.http.get('{information-model}/api/Concept', {search: params})
            .map((result) => result.json());
    }

}
