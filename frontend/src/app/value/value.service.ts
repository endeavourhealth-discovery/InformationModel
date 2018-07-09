import { Injectable } from '@angular/core';
import {Observable} from 'rxjs/Observable';
import {Http, URLSearchParams} from '@angular/http';
import {ValueSummaryList} from '../models/ValueSummaryList';

@Injectable()
export class ValueService {

  constructor(private http: Http) { }

  getMRU(): Observable<ValueSummaryList> {
    return this.http.get('api/Value/MRU')
      .map((result) => result.json());
  }

  get(id: any) {
    let params: URLSearchParams = new URLSearchParams();
    params.append('id', id);

    return this.http.get('api/Value', {search: params})
      .map((result) => result.json());
  }
}
