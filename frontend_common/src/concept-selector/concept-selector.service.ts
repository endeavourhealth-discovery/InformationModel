import {Injectable} from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs';

@Injectable()
export class ConceptSelectorService {
    constructor(private http: Http) {
    }

    getMRU(): Observable<any> {
        return this.http.get('{information-model}/api/IM/MRU')
            .map((result) => result.json());
    }

    search(searchTerm: string): Observable<any> {
        const params = new URLSearchParams();
        params.append('term', searchTerm);

        return this.http.get('{information-model}/api/IM/Search', {search: params})
            .map((result) => result.json());
    }

    getConcept(conceptId: number): Observable<any> {
        return this.http.get('{information-model}/api/IM/' + conceptId.toString())
            .map((result) => result.json());
    }
}
