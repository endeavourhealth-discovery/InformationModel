import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {Concept} from '../models/Concept';
import {ConceptSummary} from '../models/ConceptSummary';
import {RelatedConcept} from '../models/RelatedConcept';
import {ConceptSummaryList} from '../models/ConceptSummaryList';
import {Attribute} from '../models/Attribute';
import {ConceptBundle} from '../models/ConceptBundle';

@Injectable()
export class ConceptService {

  constructor(private http: Http) { }

  getMRU(): Observable<ConceptSummaryList> {
    return this.http.get('api/Concept/MRU')
      .map((result) => result.json());
  }

  search(searchTerm: string) {
      const params = new URLSearchParams();
      params.append('searchTerm', searchTerm.toString());

      return this.http.get('api/Concept/Search', {search: params})
        .map((result) => result.json());
  }

  getConcept(conceptId: number): Observable<Concept> {
    const params = new URLSearchParams();

    params.append('id', conceptId.toString());

    return this.http.get('api/Concept', {search: params})
      .map((result) => result.json());
  }

  getConceptBundle(conceptId: number): Observable<ConceptBundle> {
    const params = new URLSearchParams();

    params.append('id', conceptId.toString());

    return this.http.get('api/Concept/Bundle', {search: params})
      .map((result) => result.json());
  }


  getAttributes(conceptId: number): Observable<Attribute[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/Attribute', {search: params})
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

  getRelationships(): Observable<ConceptSummary[]> {
    return this.http.get('api/Concept/Relationships')
      .map((result) => result.json());
  }

  saveBundle(bundle: ConceptBundle): Observable<any> {
    return this.http.post('api/Concept/Bundle', bundle);
  }

  save(concept: Concept): Observable<number> {
    return this.http.post('api/Concept', concept)
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


  getAttributeOf(conceptId: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    return this.http.get('api/Concept/AttributeOf', {search: params})
      .map((result) => result.json());
  }


  saveAttribute(conceptId: number, attributeId: number): Observable<any> {
    const params = new URLSearchParams();
    params.append('conceptId', conceptId.toString());
    params.append('attributeId', attributeId.toString());
    return this.http.post('api/Concept/Attribute', {}, {search: params})
      .map((result) => result.json());
  }

  saveRelationship(sourceId: number, targetId: number, relationshipId: number): Observable<any> {
    const params = new URLSearchParams();
    params.append('sourceId', sourceId.toString());
    params.append('targetId', targetId.toString());
    params.append('relationshipId', relationshipId.toString());
    return this.http.post('api/Concept/Relationship', {}, {search: params})
      .map((result) => result.json());
  }

}
