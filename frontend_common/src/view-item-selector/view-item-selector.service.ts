import {Injectable} from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs';

@Injectable()
export class ViewItemSelectorService {
    constructor(private http: Http) {
    }

    getView(viewId: string): Observable<any> {
        return this.http.get('{information-model}/api/Common/View/' + viewId)
            .map((result) => result.json());
    }
}
