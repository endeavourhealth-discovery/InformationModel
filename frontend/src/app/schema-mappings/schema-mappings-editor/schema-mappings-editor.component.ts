import {AfterViewInit, Component} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {Location} from '@angular/common';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {SchemaMappingsService} from '../schema-mappings.service';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-schema-mappings-editor',
  templateUrl: './schema-mappings-editor.component.html',
  styleUrls: ['./schema-mappings-editor.component.css']
})
export class SchemaMappingsEditorComponent implements AfterViewInit {
  schemaMaps: any[];

  constructor(private route: ActivatedRoute,
              private location: Location,
              private modal: NgbModal,
              private log: LoggerService,
              private service: SchemaMappingsService) { }

  ngAfterViewInit() {
    this.route.params.subscribe(
      (params) => this.loadSchemaMaps(params['id'])
    );
  }

  loadSchemaMaps(conceptId: number) {
    this.service.getSchemaMaps(conceptId).
      subscribe(
      (result) => this.schemaMaps = result,
      (error) => this.log.error(error)
    );
  }

  save() {
    this.location.back();
  }
  close(withConfirm: boolean) {
    this.location.back();
  }
}
