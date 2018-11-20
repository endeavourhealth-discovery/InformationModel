import { Injectable } from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs/Observable';
import {View} from '../models/View';
import {ViewItem} from '../models/ViewItem';

@Injectable()
export class ViewService {

  constructor(private http: Http) { }

  getViews(): Observable<View[]> {
    return this.http.get('api/View')
      .map((result) => result.json());
  }

  getView(id: number) {
    return this.http.get('api/View/' + id.toString())
      .map((result) => result.json());
  }

  save(view: View) {
    return this.http.post('api/View', view)
      .map((result) => result.json());
  }

  getViewContents(viewId: number, parentId: number): Observable<ViewItem[]> {
    const params = new URLSearchParams();
    if (parentId)
      params.append('parentId', parentId.toString());
    return this.http.get('api/View/' + viewId + '/Children', {search: params})
      .map((result) => result.json());
  }

  addViewItem(viewId: number, addStyle: string, conceptId: number, attributeIds: number[], parentId: number): Observable<any> {
    const params = new URLSearchParams();
    params.append('addStyle', addStyle);
    if (parentId != null)
      params.append('parentId', parentId.toString());
    return this.http.post('api/View/' + viewId + '/Item/' + conceptId, attributeIds, {search: params});
  }

  delete(viewId: number): Observable<any> {
    return this.http.delete('api/View/' + viewId);
  }

  removeViewItem(viewItemId: number): Observable<any> {
    return this.http.delete('api/View/ViewItem/'+viewItemId.toString());
  }
}
