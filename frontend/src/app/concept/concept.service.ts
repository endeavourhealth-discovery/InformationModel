import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {Concept} from '../models/Concept';
import {ConceptSummary} from '../models/ConceptSummary';
import {RelatedConcept} from '../models/RelatedConcept';

@Injectable()
export class ConceptService {

  constructor(private http: Http) { }

  getConcept(conceptId: number): Observable<Concept> {
    const params = new URLSearchParams();

    params.append('id', conceptId.toString());

    return this.http.get('api/Concept', {search: params})
      .map((result) => result.json());
  }

  getSummaries(page?: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();

    if (page) {
      params.append('page', page.toString());
    }

    return this.http.get('api/Concept/Summaries', {search: params})
      .map((result) => result.json());
  }

  save(model: Concept): Observable<number> {
    return this.http.post('api/Concept', model)
      .map((result) => result.json());
  }

  find(criteria: string): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();
    params.append('criteria', criteria);

    return this.http.get('api/Concept/Search', {search: params})
      .map((result) => result.json());
  }

  createDraftConcept(concept: Concept): Observable<number> {
    return this.http.post('api/Concept', concept)
      .map((result) => result.json());
  }

  getRelatedTargets(conceptId: number): Observable<RelatedConcept[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/RelatedTargets', {search: params})
      .map((result) => result.json());
  }

  getRelatedSources(conceptId: number): Observable<RelatedConcept[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/RelatedSources', {search: params})
      .map((result) => result.json());
  }

  getAttributes(conceptId: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/Attribute', {search: params})
      .map((result) => result.json());
  }
  getAttributeOf(conceptId: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/AttributeOf', {search: params})
      .map((result) => result.json());
  }
}
