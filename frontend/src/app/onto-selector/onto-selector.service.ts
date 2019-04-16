import {Injectable} from '@angular/core';
import {Http, URLSearchParams} from '@angular/http';
import {Observable} from 'rxjs';

@Injectable()
export class OntoSelectorService {
  private base: string = 'https://ontoserver.dataproducts.nhs.uk/fhir';
  private vset: string = 'http://snomed.info/sct?fhir_vs=isa/138875005';
    constructor(private http: Http) {
    }

    search(searchTerm: string, ): Observable<any> {
        const params = new URLSearchParams();
        params.append('identifier', this.vset);
        params.append('filter', searchTerm);
        params.append('count', '10');

        return this.http.get(this.base + '/ValueSet/$expand', {search: params})
            .map((result) => result.json());
    }
}
