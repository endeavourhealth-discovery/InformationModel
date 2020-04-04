import { Injectable } from '@angular/core';
import {HttpClient, HttpParams} from '@angular/common/http';
import {Observable} from 'rxjs';
import {Concept} from '../models/Concept';
import {Related} from '../models/Related';

@Injectable({
  providedIn: 'root'
})
export class RecordModelService {

  constructor(private http: HttpClient) { }

  getTargets(id: string, relationships: string[]): Observable<Related[]> {
    let params = new HttpParams();
    if (relationships != null) {
      relationships.forEach(r => params = params.append('relationship', r));
    }

    return this.http.get<Related[]>('public/Viewer/' + id + '/Targets', {params});
  }

  getSources(id: string, relationships: string[]): Observable<Related[]> {
    let params = new HttpParams();
    if (relationships != null) {
      relationships.forEach(r => params = params.append('relationship', r));
    }

    return this.http.get<Related[]>('public/Viewer/' + id + '/Sources', {params});
  }

  getConcept(id: string): Observable<Concept> {
    return this.http.get<Concept>('public/Viewer/' + id);
  }

  search(searchTerm: string) {
    let params = new HttpParams();
    params = params.append('term', searchTerm);
    return this.http.get<any>('public/Viewer/search', {params});
  }
}
