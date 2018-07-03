import { Component, OnInit } from '@angular/core';
import {ConceptService} from '../concept.service';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptSummary} from '../../models/ConceptSummary';
import {ConceptStatus} from '../../models/ConceptStatus';
import {ConceptReference} from '../../models/ConceptReference';

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
  relationships: ConceptReference[] = [
    {
      id: 0,
      text: 'Has attribute',
    }
  ];
  linkage: ConceptReference;

  constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  ngOnInit() {
    this.conceptService.getRelationships()
      .subscribe(
        (result) => this.relationships = this.relationships.concat(result),
        (error) => this.logger.error(error)
      );
  }

  setLinkage(linkage: ConceptReference) {
    this.linkage = linkage;
  }

  getLinkageText() {
    return this.linkage?this.linkage.text:null;
  }

  ok() {
    if (!this.targetConcept.id) {
      this.conceptService.save(this.targetConcept)
        .subscribe(
          (result) => {
            this.targetConcept.id = result;
            this.activeModal.close(this.linkage);
          }
        );
    } else
      this.activeModal.close(this.linkage);
  }

  cancel() {
    this.activeModal.close();
  }
}
