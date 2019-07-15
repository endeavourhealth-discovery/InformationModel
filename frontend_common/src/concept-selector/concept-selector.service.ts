import {Injectable} from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs';
import {KVP} from '../models/KVP';

@Injectable()
export class ConceptSelectorService {
    constructor(private http: Http) {
    }

    getCodeSchemes(): Observable<KVP[]> {
        return this.http.get('{information-model}/api/Common/CodeScheme')
            .map((result) => result.json());
    }

    search(term: string, schemes: number[]): Observable<any> {
        const params = new URLSearchParams();
        params.append('term', term);

        if (schemes) {
            for (let kvp of schemes) {
                params.append('scheme', kvp.toString())
            }
        }


        return this.http.get('{information-model}/api/Common/Concept/Search', {search: params})
            .map((result) => result.json());
    }

    getForwardRelated(id: string, relationships: string[]): Observable<any> {
        const params = new URLSearchParams();

        for (let rel of relationships)
            params.append('relationship', rel);

        return this.http.get('{information-model}/api/Common/Concept/'+id+'/Related', {search: params})
            .map((result) => result.json());
    }

    getBackwardRelated(id: string, relationships: string[]): Observable<any> {
        const params = new URLSearchParams();

        for (let rel of relationships)
            params.append('relationship', rel);

        return this.http.get('{information-model}/api/Common/Concept/'+id+'/Related/Reverse', {search: params})
            .map((result) => result.json());
    }

}
