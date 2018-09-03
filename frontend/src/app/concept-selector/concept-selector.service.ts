import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from '../../../node_modules/rxjs/Observable';
import {Concept} from '../models/Concept';
import {IdText} from '../models/IdText';
import {ConceptSummaryList} from '../models/ConceptSummaryList';

@Injectable()
export class ConceptSelectorService {
  constructor(private http: Http) { }

  getCodeSystems(): Observable<IdText[]> {
    return this.http.get('api/Code/System')
      .map((result) => result.json());
  }

  search(searchTerm: string, activeOnly: boolean, codeSystems: number[]): Observable<ConceptSummaryList> {
    const params = new URLSearchParams();
    params.append('term', searchTerm.toString());
    params.append('activeOnly', activeOnly.toString());
    if (codeSystems) {
      for (const systemId of codeSystems) {
        params.append('codeSystem', systemId.toString());
      }
    }

    return this.http.get('api/Code/Term', {search: params})
      .map((result) => result.json());
  }

  getConcept(conceptId: number): Observable<Concept> {
    const params = new URLSearchParams();

    params.append('id', conceptId.toString());

    return this.http.get('api/Concept', {search: params})
      .map((result) => result.json());
  }


}
