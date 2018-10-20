import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {Concept} from '../models/Concept';
import {RelatedConcept} from '../models/RelatedConcept';
import {Attribute} from '../models/Attribute';
import {ConceptEdits} from '../models/ConceptEdits';
import {Bundle} from '../models/Bundle';
import {Synonym} from '../models/Synonym';
import {ConceptSummary} from '../models/ConceptSummary';
import {SearchResult} from 'im-common/dist/models/SearchResult';

@Injectable()
export class ConceptService {

  constructor(private http: Http) { }

  getMRU(includeDeprecated: boolean): Observable<SearchResult> {
    const params = new URLSearchParams();
    params.append('includeDeprecated', includeDeprecated.toString());

    return this.http.get('api/Concept/MRU', {search: params})
      .map((result) => result.json());
  }

  search(searchTerm: string, includeDeprecated: boolean, page:number = 1): Observable<SearchResult> {
    const params = new URLSearchParams();
    params.append('searchTerm', searchTerm.toString());
    params.append('includeDeprecated', includeDeprecated.toString());
    params.append('page', page.toString());

    return this.http.get('api/Concept/Search', {search: params})
      .map((result) => result.json());
  }

  getConcept(conceptId: number): Observable<Concept> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());

    return this.http.get('api/Concept', {search: params})
      .map((result) => result.json());
  }

  getRelated(conceptId: number, includeDeprecated: boolean): Observable<RelatedConcept[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    params.append('includeDeprecated', includeDeprecated.toString());

    return this.http.get('api/Concept/Related', {search: params})
      .map((result) => result.json());
  }

  getAttributes(conceptId: number, includeDeprecated: boolean): Observable<Attribute[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());
    params.append('includeDeprecated', includeDeprecated.toString());

    return this.http.get('api/Concept/Attributes', {search: params})
      .map((result) => (result.text() === '') ? null : result.json());
  }

  getSynonyms(conceptId: number): Observable<Synonym[]> {
    const params = new URLSearchParams();
    params.append('id', conceptId.toString());

    return this.http.get('api/Concept/Synonyms', {search: params})
      .map((result) => (result.text() === '') ? null : result.json());
  }

  save(concept: Concept, edits: ConceptEdits): Observable<Bundle> {
    const bundle = {
      concept: concept,
      edits: edits
    };

    return this.http.post('api/Concept', bundle).map((result) => result.json());
  }
}
