import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptService} from '../concept.service';
import {ConceptStatusHelper} from '../../models/ConceptStatus';
import {Synonym} from '../../models/Synonym';

@Component({
  selector: 'app-synonym-editor',
  templateUrl: './synonym-editor.component.html',
  styleUrls: ['./synonym-editor.component.css']
})
export class SynonymEditorComponent implements OnInit {
  result: Synonym[];
  getStatusName = ConceptStatusHelper.getName;

  public static open(modalService: NgbModal, synonyms: Synonym[]) {
    const modalRef = modalService.open(SynonymEditorComponent, { backdrop: 'static'});
    modalRef.componentInstance.result = synonyms;
    return modalRef;
  }

  constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  ngOnInit() {
  }

  ok() {
    this.activeModal.close(this.result);
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
