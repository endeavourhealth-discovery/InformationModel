import {Component, OnInit} from '@angular/core';
import {NgbActiveModal, NgbModal, NgbModalRef} from '@ng-bootstrap/ng-bootstrap';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {ConceptSelectorService} from '../concept-selector.service';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptSummary} from '../../models/ConceptSummary';

@Component({
  selector: 'app-concept-selector',
  template: `<div [hidden]="hide">
    <div class="modal-header">
      <h4 class="modal-title">Select concept</h4>
      <button type="button" class="close" (click)="cancel()" aria-hidden="true">&times;</button>
    </div>
    <div class="modal-body">
      <div class="container-fluid">
        <div class="row">
          <div class="form-group col-md-9">
            <label class="control-label">Search criteria</label>
            <div class="input-group">
              <input class="form-control" type="text" [(ngModel)]="criteria" name="filter" autofocus (keyup.enter)="search()">
              <div class="input-group-append">
                <span class="input-group-text" (click)="search()"><i class="fa fa-search"></i></span>
              </div>
            </div>
          </div>
          <div class="form-group col-md-3">
            <label class="control-label">Search options</label>
            <div class="custom-control custom-checkbox form-control-plaintext">
              <input type="checkbox" class="custom-control-input" [(ngModel)]="includeDeprecated" id="chkIncDep">
              <label class="custom-control-label" for="chkIncDep">Include deprecated</label>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <loadingIndicator [done]="result">
              <div class="scroll-box-350">
                <table class="table table-striped table-hover table-sm">
                  <thead>
                    <tr class="d-flex">
                      <th class="col-8">Term</th>
                      <th class="col-3">Context</th>
                      <th class="col-1">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr class="d-flex" *ngFor="let item of result" (click)="selection=item" (dblclick)="ok()" [class.selection]="selection==item" [class.text-warning]="item.status == 2">
                      <td class="col-8">{{item.name}} <span *ngIf="item.synonym" class="badge badge-info">Synonym</span></td>
                      <td class="col-3">{{item.context}}</td>
                      <td class="col-1">{{getConceptStatusName(item.status)}}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </loadingIndicator>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-success" (click)="add()" name="add" *ngIf="showAdd">Add new</button>
      <button type="button" class="btn btn-success" (click)="ok()" name="Ok" [disabled]="selection==null">Select</button>
      <button type="button" class="btn btn-danger" (click)="cancel()" name="cancel">Cancel</button>
    </div>
  </div>
  `
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

  public static open(modalService: NgbModal, showAdd: boolean = false, superclass: number = null): NgbModalRef {
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
