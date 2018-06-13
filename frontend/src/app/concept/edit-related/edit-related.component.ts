import { Component, OnInit } from '@angular/core';
import {ConceptService} from '../concept.service';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';

@Component({
  selector: 'app-edit-related',
  templateUrl: './edit-related.component.html',
  styleUrls: ['./edit-related.component.css']
})
export class EditRelatedComponent implements OnInit {

  public static open(modalService: NgbModal, sourceConcept: Concept, targetConcept: Concept) {
    const modalRef = modalService.open(EditRelatedComponent, { backdrop: 'static'});
    modalRef.componentInstance.sourceConcept = sourceConcept;
    modalRef.componentInstance.targetConcept = targetConcept;
    return modalRef;
  }

  sourceConcept: Concept;
  targetConcept: Concept;
  readonly: boolean;

  constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  ngOnInit() {
  }

  ok() {
    this.activeModal.close();
  }

  cancel() {
    this.activeModal.close();
  }
}
