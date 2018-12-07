import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';

@Injectable()
export class SchemaMappingsService {

  constructor(private http: Http) { }

  getRecordTypes() {
    return this.http.get('api/SchemaMappings/RecordTypes')
      .map((result) => result.json());
  }

  getSchemaMaps(conceptId: number) {
    return this.http.get('api/SchemaMappings/' + conceptId)
      .map((result) => result.json());
  }
}
