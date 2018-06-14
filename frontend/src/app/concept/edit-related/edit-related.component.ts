import { Component, OnInit } from '@angular/core';
import {ConceptService} from '../concept.service';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptSummary} from '../../models/ConceptSummary';
import {ConceptStatus} from '../../models/ConceptStatus';

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
  relationships: ConceptSummary[] = [
    {
      id: 0,
      context: 'Attribute',
      name: 'Has attribute',
      status: ConceptStatus.ACTIVE,
      version: '1.0'
    }
  ];
  linkage: ConceptSummary;

  constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  ngOnInit() {
    this.conceptService.getRelationships()
      .subscribe(
        (result) => this.relationships = this.relationships.concat(result),
        (error) => this.logger.error(error)
      );
  }

  setLinkage(linkage: ConceptSummary) {
    this.linkage = linkage;
  }

  getLinkageText() {
    return this.linkage?this.linkage.name:null;
  }

  ok() {
    this.activeModal.close(this.linkage);
  }

  cancel() {
    this.activeModal.close();
  }
}
