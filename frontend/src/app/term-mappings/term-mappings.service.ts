import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {ConceptSummary} from '../models/ConceptSummary';
import {TermMapping} from '../models/TermMapping';

@Injectable()
export class TermMappingsService {

  constructor(private http: Http) { }

  getSummaries(page?: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();

    if (page) {
      params.append('page', page.toString());
    }

    return this.http.get('api/Concept/Summaries', {search: params})
      .map((result) => result.json());
  }

  getMappings(conceptId: number): Observable<TermMapping[]> {
    const params = new URLSearchParams();
    params.append("concept_id", conceptId.toString());
    return this.http.get('api/Term/Mappings', {search: params})
      .map((result) => result.json());
  }

  getRelatedTargets(conceptId: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/RelatedTargets', {search: params})
      .map((result) => result.json());
  }

  getRelatedSources(conceptId: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/RelatedSources', {search: params})
      .map((result) => result.json());
  }

}
