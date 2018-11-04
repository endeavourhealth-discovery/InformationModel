import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {View} from '../models/View';
import {ViewFolder} from '../models/ViewFolder';
import {ConceptSummary} from '../models/ConceptSummary';

@Injectable()
export class ViewService {

  constructor(private http: Http) { }

  getViews(parent: number = null): Observable<View[]> {
    const params = new URLSearchParams();
    if (parent != null)
      params.append('parent', parent.toString());
    return this.http.get('api/View/List', {search: params})
      .map((result) => result.json());
  }

  save(view: View): Observable<View> {
    return this.http.post('api/View', view)
      .map((result) => result.json());
  }

  get(id: any): Observable<View> {
    const params = new URLSearchParams();
    params.append('id', id.toString());
    return this.http.get('api/View', {search: params})
      .map((result) => result.json());
  }

  getConcepts(id: number): Observable<ConceptSummary[]> {
    const params = new URLSearchParams();
    params.append('id', id.toString());
    return this.http.get('api/View/Concepts', {search: params})
      .map((result) => result.json());
  }
}
