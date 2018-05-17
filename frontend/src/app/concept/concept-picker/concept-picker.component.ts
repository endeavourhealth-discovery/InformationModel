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
  result: ConceptSummary[] = [];
  selection: ConceptSummary;

  public static open(modalService: NgbModal) {
    const modalRef = modalService.open(ConceptPickerComponent, { backdrop: 'static'});
    return modalRef;
  }

  constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  ngOnInit() {
  }

  search() {
    this.result = null;
    this.conceptService.find(this.criteria)
      .subscribe(
        (result) => this.result = result,
        (error) => this.logger.error(error)
      );
  }

  new() {
    this.selection = new Concept();
    this.selection.context = this.criteria;
    this.ok();
  }

  ok() {
    this.activeModal.close(this.selection);
  }

  cancel() {
    this.activeModal.dismiss('cancel');
  }
}
