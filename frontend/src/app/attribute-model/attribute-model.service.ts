import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {AttributeModelSummary} from '../models/AttributeModelSummary';
import {Attribute} from '../models/Attribute';

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

  getAttributes(conceptId: number): Observable<Attribute[]> {
    const params = new URLSearchParams();
    params.append('conceptId', conceptId.toString());

    return this.http.get('api/AttributeModel/Attributes', {search: params})
      .map((result) => result.json());
  }
}
