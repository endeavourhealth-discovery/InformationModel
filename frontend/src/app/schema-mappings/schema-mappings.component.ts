import { Component, OnInit } from '@angular/core';
import {SchemaMappingsService} from './schema-mappings.service';
import {LoggerService} from 'eds-angular4';
import {SearchResult} from 'im-common/dist/models/SearchResult';
import {ConceptSummary} from 'im-common/dist/models/ConceptSummary';
import {Router} from '@angular/router';

@Component({
  selector: 'app-schema-mappings',
  templateUrl: './schema-mappings.component.html',
  styleUrls: ['./schema-mappings.component.css']
})
export class SchemaMappingsComponent implements OnInit {
  recordTypes: SearchResult;

  constructor(private service: SchemaMappingsService, private log: LoggerService, private router: Router) { }

  ngOnInit() {
    this.service.getRecordTypes()
      .subscribe(
        (result) => this.recordTypes = result,
        (error) => this.log.error(error)
      );
  }

  editSchemaMappings(concept: ConceptSummary) {
     this.router.navigate(['schemaMappings', concept.id]);
  }

}
