import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {TermMapping} from '../models/TermMapping';
import {ConceptSummaryList} from '../models/ConceptSummaryList';

@Injectable()
export class TermMappingsService {

  constructor(private http: Http) { }

  getSummaries(page?: number): Observable<ConceptSummaryList> {
    return this.http.get('api/Concept/MRU')
      .map((result) => result.json());
  }

  getMappings(conceptId: number): Observable<TermMapping[]> {
    const params = new URLSearchParams();
    params.append("concept_id", conceptId.toString());
    return this.http.get('api/Term/Mappings', {search: params})
      .map((result) => result.json());
  }
}
