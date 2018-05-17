import { Injectable } from '@angular/core';
import {Observable} from 'rxjs/Observable';
import {URLSearchParams, Http} from '@angular/http';
import {Task} from '../models/Task';

@Injectable()
export class WorkflowManagerService {

  constructor(private http: Http) {
  }

  getTasks(taskType?: number): Observable<Task[]> {
    const params = new URLSearchParams();

    if (taskType != null) {
      params.append('TaskTypeId', taskType.toString());
    }

    return this.http.get('api/Task', {search: params})
      .map((result) => result.json());
  }
}
