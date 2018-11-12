import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptService} from '../concept.service';
import {ConceptStatusHelper} from '../../models/ConceptStatus';
import {Attribute} from '../../models/Attribute';
import {Concept} from '../../models/Concept';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {ValueExpressionHelper} from '../../models/ValueExpression';

@Component({
  selector: 'app-attribute-editor',
  templateUrl: './attribute-editor.component.html',
  styleUrls: ['./attribute-editor.component.css']
})
export class AttributeEditorComponent implements OnInit {
  conceptId: number;
  result: Attribute;

  getValueExpressionPrefix = ValueExpressionHelper.getPrefix;
  expressionOptions = ValueExpressionHelper.getOptions();

  public static open(modalService: NgbModal, conceptId: number, attribute: Attribute) {
    const modalRef = modalService.open(AttributeEditorComponent, { backdrop: 'static'});
    modalRef.componentInstance.conceptId = conceptId;
    modalRef.componentInstance.result = Object.assign({}, attribute);
    return modalRef;
  }

  constructor(private modal: NgbModal, public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptService) { }

  isLiteral() {
    return this.result.valueConcept.id >= 8 && this.result.valueConcept.id <= 13;
  }

  search() {
    const concept = (this.result.valueConcept.id == 7) ? 2 : this.result.valueConcept.id;
    ConceptSelectorComponent.open(this.modal, false, concept, this.result.valueExpression)
      .result.then(
      (result: Concept) => this.result.fixedConcept = {id: result.id, name: result.fullName},
      () => {}
    );
  }

  selectValueConcept() {
    ConceptSelectorComponent.open(this.modal, false)
      .result.then(
      (result: Concept) => this.result.fixedConcept = {id: result.id, name: result.fullName},
      () => {}
    );
  }

  ngOnInit() {
  }

  ok() {
    this.activeModal.close(this.result);
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
