import {Component, OnInit} from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {ConceptSelectorService} from '../concept-selector.service';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptSummary} from '../../models/ConceptSummary';

@Component({
  selector: 'app-concept-selector',
  templateUrl: './concept-selector.component.html',
  styleUrls: ['./concept-selector.component.css']
})
export class ConceptSelectorComponent implements OnInit {
  hide: boolean;
  criteria: string;
  includeDeprecated = false;
  selection: Concept;
  result: ConceptSummary[] = [];
  showAdd: boolean = false;
  superclass: number;

  getConceptStatusName = ConceptStatusHelper.getName;

  public static open(modalService: NgbModal, showAdd: boolean = false, superclass: number = null) {
    const modalRef = modalService.open(ConceptSelectorComponent, { backdrop: 'static', size: 'lg'});
    modalRef.componentInstance.showAdd = showAdd;
    modalRef.componentInstance.superclass = superclass;
    return modalRef;
  }

  constructor(public modal: NgbModal, public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptSelectorService) { }

  ngOnInit() {
  }

  search() {
    this.result = null;

    this.conceptService.search(this.criteria, this.includeDeprecated, this.superclass)
      .subscribe(
        (result) => this.result = result,
        (error) => this.logger.error(error)
      );
  }

  add() {
    this.hide = true;
    InputBoxDialog.open(this.modal, 'New concept', 'Enter name for new concept', '', 'Create', 'Cancel')
      .result.then(
      (result) => this.createAndClose(result),
      (cancel) => this.activeModal.close(null)
    );
  }

  createAndClose(name: string) {
    const result: Concept = {
      id: null,
      superclass: {id: 1, name: 'Concept'},
      fullName: name,
      context: name.replace(' ',''),
      description: name,
      shortName: name,
      useCount: 0,
      version: 0.1,
      status: ConceptStatus.DRAFT,
      url: ''
    };

    this.activeModal.close(result);
  }

  ok() {
    if (this.selection) {
      this.conceptService.getConcept(this.selection.id)
        .subscribe(
          (result) => this.activeModal.close(result),
          (error) => this.logger.error(error)
        );
    }
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
