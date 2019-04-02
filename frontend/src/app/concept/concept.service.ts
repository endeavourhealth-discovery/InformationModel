import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {Concept} from '../models/Concept';
import {SearchResult} from '../models/SearchResult';

@Injectable()
export class ConceptService {

  constructor(private http: Http) { }

  getDocuments(): Observable<string[]> {
    return this.http.get('api/IM/document')
      .map((result) => result.json());
  }

  getMRU(): Observable<SearchResult> {
    return this.http.get('api/IM/MRU')
      .map((result) => result.json());
  }

  search(searchTerm: string, size?: number, page?: number, relationship?: string, target?: string): Observable<SearchResult> {
    const params = new URLSearchParams();
    params.append('term', searchTerm);
    if (size) params.append('size', size.toString());
    if (page) params.append('page', page.toString());
    if (relationship) params.append('relationship', relationship);
    if (target) params.append('target', target);

    return this.http.get('api/IM/Search', {search: params})
      .map((result) => result.json());
  }

  getConcept(id: string): Observable<Concept> {
    return this.http.get('api/IM/' + id)
      .map((result) => result.json());
  }

  getName(id: string): Observable<string> {
    return this.http.get('api/IM/' + id + '/name')
      .map((result) => result.status == 204 ? null : result.text());
  }

  validateIds(ids: string[]) {
    return this.http.post('api/IM/ValidateIds', ids)
      .map((result) => result.text());
  }

  insertConcept(concept: any): Observable<any> {
    return this.http.post('api/IM', concept);
  }

  updateConcept(concept: any, status: number): Observable<any> {
    const id = concept['id'];
    const params = new URLSearchParams();
    params.append('status', status.toString());
      return this.http.post('api/IM/'+id, concept, {search: params});
  }

  deleteConcept(id: string): Observable<any> {
    return this.http.delete('api/IM/' + id);
  }

  generateRuntime(): Observable<any> {
    return this.http.get('api/IM/runtime/generate');
  }

  loadRuntime(): Observable<any> {
    return this.http.get('api/IM/runtime/load');
  }
}
