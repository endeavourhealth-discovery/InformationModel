import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {ConceptSummary} from '../models/ConceptSummary';

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
}
