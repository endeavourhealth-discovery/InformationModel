import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {AttributeModelSummary} from '../models/AttributeModelSummary';

@Injectable()
export class AttributeModelService {

  constructor(private http: Http) { }

  getSummaries(page?: number): Observable<AttributeModelSummary[]> {
    const params = new URLSearchParams();

    if (page) {
      params.append('page', page.toString());
    }

    return this.http.get('api/AttributeModel/Summaries', {search: params})
      .map((result) => result.json());
  }
}
