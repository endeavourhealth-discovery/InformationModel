import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptService} from '../concept.service';
import {ConceptSummary} from '../../models/ConceptSummary';
import {Concept} from '../../models/Concept';

@Component({
  selector: 'app-concept-picker',
  templateUrl: './concept-picker.component.html',
  styleUrls: ['./concept-picker.component.css']
})
export class ConceptPickerComponent implements OnInit {
  criteria = '';
  allowAddNew: boolean = false;
  result: ConceptSummary[] = [];
  selection: ConceptSummary;

  public static open(modalService: NgbModal, allowAddNew: boolean) {
    const modalRef = modalService.open(ConceptPickerComponent, { backdrop: 'static'});
    modalRef.componentInstance.allowAddNew = allowAddNew;
    return modalRef;
  }

  constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  ngOnInit() {
  }

  search() {
    this.result = null;
    this.conceptService.search(this.criteria)
      .subscribe(
        (result) => this.result = result.concepts,
        (error) => this.logger.error(error)
      );
  }

  new() {
    let newConcept = new Concept();
    newConcept.context = this.criteria;
    this.activeModal.close(newConcept);
  }

  ok() {
    this.conceptService.getConcept(this.selection.id)
      .subscribe(
        (result) => this.activeModal.close(result),
        (error) => this.logger.error(error)
      );
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
