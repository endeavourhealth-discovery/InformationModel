import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {Concept} from '../models/Concept';
import {Attribute} from '../models/Attribute';
import {Synonym} from '../models/Synonym';
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
    return this.http.get('api/Concept/' + conceptId.toString())
      .map((result) => result.json());
  }

  // getRelated(conceptId: number, includeDeprecated: boolean): Observable<RelatedConcept[]> {
  //   const params = new URLSearchParams();
  //   params.append('id', conceptId.toString());
  //   params.append('includeDeprecated', includeDeprecated.toString());
  //
  //   return this.http.get('api/Concept/Related', {search: params})
  //     .map((result) => result.json());
  // }

  getAttributes(conceptId: number, includeDeprecated: boolean): Observable<Attribute[]> {
    const params = new URLSearchParams();
    params.append('includeDeprecated', includeDeprecated.toString());

    return this.http.get('api/Concept/' + conceptId.toString() + '/Attribute', {search: params})
      .map((result) => (result.text() === '') ? null : result.json());
  }

  getSynonyms(conceptId: number): Observable<Synonym[]> {
    return this.http.get('api/Concept/' + conceptId.toString() + '/Synonyms')
      .map((result) => (result.text() === '') ? null : result.json());
  }

  save(concept: Concept): Observable<Concept> {
    return this.http.post('api/Concept', concept)
      .map((result) => result.json());
  }

  deleteConcept(id: number): Observable<any> {
    return this.http.delete('api/Concept/' + id.toString());
  }

  saveAttribute(id: number, attribute: Attribute): Observable<Attribute> {
    return this.http.post('api/Concept/' + id.toString() + '/Attribute', attribute)
      .map((result) => result.json());
  }

  deleteAttribute(id: number): Observable<any> {
    return this.http.delete('api/Concept/Attribute/' + id.toString());
  }
}
