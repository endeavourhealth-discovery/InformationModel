import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptService} from '../concept.service';
import {RelatedConcept} from '../../models/RelatedConcept';
import {ConceptSelectorComponent} from '../../concept-selector/concept-selector/concept-selector.component';
import {Concept} from '../../models/Concept';

@Component({
  selector: 'app-related-editor',
  templateUrl: './related-editor.component.html',
  styleUrls: ['./related-editor.component.css']
})
export class RelatedEditorComponent implements OnInit {
  conceptId: number;
  original: RelatedConcept;
  result: RelatedConcept;

  public static open(modalService: NgbModal, conceptId: number, related: RelatedConcept) {
    const modalRef = modalService.open(RelatedEditorComponent, { backdrop: 'static'});
    modalRef.componentInstance.conceptId = conceptId;
    modalRef.componentInstance.original = related;
    modalRef.componentInstance.result = Object.assign({}, related);
    return modalRef;
  }

  constructor(public modal:NgbModal, public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  ngOnInit() {
  }

  swap() {
    const tmp = this.result.source;
    this.result.source = this.result.target;
    this.result.target = tmp;
  }

  selectSource() {
    ConceptSelectorComponent.open(this.modal, false)
      .result.then(
      (result: Concept) => {this.result.source = {id: result.id, name: result.fullName}},
      (error) => {}
    );
  }

  selectRelationship() {
    ConceptSelectorComponent.open(this.modal, false, 5)
      .result.then(
      (result: Concept) => {this.result.relationship = {id: result.id, name: result.fullName}},
      (error) => {}
    );
  }

  selectTarget() {
    ConceptSelectorComponent.open(this.modal, false)
      .result.then(
      (result: Concept) => {this.result.target = {id: result.id, name: result.fullName}},
      (error) => {}
    );
  }

  ok() {
    Object.assign(this.original, this.result);
    this.activeModal.close(this.result);
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
