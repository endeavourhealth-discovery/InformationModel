import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {ConceptService} from '../concept.service';
import {Attribute} from '../../models/Attribute';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {ValueExpressionHelper} from '../../models/ValueExpression';
import {Concept} from 'im-common/dist/models/Concept';

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
    return this.result.valueConcept && this.result.valueConcept.id >= 8 && this.result.valueConcept.id <= 13;
  }

  selectValueType() {
    ConceptSelectorComponent.open(this.modal, false)
      .result.then(
      (result: Concept) => this.result.valueConcept = {id: result.id, name: result.fullName},
      () => {}
    );
  }

  selectFixedConcept() {
    ConceptSelectorComponent.open(this.modal, false)
      .result.then(
      (result: Concept) => this.result.fixedConcept = {id: result.id, name: result.fullName},
      () => {}
    );
  }

  clearFixedConcept() {
    MessageBoxDialog.open(this.modal, 'Clear concept', 'Do you want to clear the fixed concept for this attribute?', 'Clear', 'Cancel')
      .result.then(
      (clear) => this.result.fixedConcept = null,
      (cancel) => {}
    );

  }

  ngOnInit() {
  }

  ok() {
    this.conceptService.saveAttribute(this.conceptId, this.result)
      .subscribe(
        (result) => this.activeModal.close(result),
        (error) => this.logger.error(error)
      );
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
