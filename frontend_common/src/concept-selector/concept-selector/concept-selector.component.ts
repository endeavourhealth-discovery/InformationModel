import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal, NgbModalRef} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptSelectorService} from '../concept-selector.service';
import {KVP} from '../../models/KVP';
import {CodeableConcept} from '../../models/CodeableConcept';
import {ConceptSelection} from '../../models/ConceptSelection';
import {SearchResult} from '../../models/SearchResult';
import {Related} from '../../models/Related';

@Component({
    selector: 'app-concept-selector',
    template: `
      <div>
        <div class="modal-header">
          <h4 class="modal-title">Select concept</h4>
          <button type="button" class="close" (click)="cancel()" aria-hidden="true">&times;</button>
        </div>
        <div class="modal-body">
          <div class="container-fluid">
            <div class="row">
              <div class="form-group col-md-6">
                <label class="control-label">Search criteria</label>
                <div class="input-group" id="conceptSelectorSearch">
                  <input class="form-control" type="text" [(ngModel)]="term" name="filter" #focus autofocus (keyup.enter)="search()">
                  <div class="input-group-append">
                    <button class="input-group-text" (click)="search()"><i class="fa fa-search"></i></button>
                  </div>
                </div>
              </div>
              <div class="form-group col-md-6">
                <label class="control-label">Code scheme(s)</label>
                <multiSelectDropdown idField="key" nameField="value" [data]="codeSchemes" [(ngModel)]="selectedCodeSchemes" noneText="All"></multiSelectDropdown>
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-8">
                <loadingIndicator [done]="searchResult">
                  <label class="control-label">Search results</label>
                  <div class="scroll-box-300">
                    <table class="table table-striped table-hover table-sm">
                      <thead>
                        <tr class="d-flex">
                          <th class="col-2">Scheme</th>
                          <th class="col-2">Code</th>
                          <th class="col-8">Name</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr class="d-flex" *ngFor="let item of searchResult?.results" (click)="select(item)" (dblclick)="addSelection(item, true)" [class.selection]="searchSelection==item" [class.text-warning]="item.status == 2">
                          <td class="col-2">{{item.scheme}}</td>
                          <td class="col-2">{{item.code}}</td>
                          <td class="col-8">{{item.name}}</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </loadingIndicator>
              </div>
              <div class="form-group col-md-4" *ngIf="parents || children || maps">
                <label class="control-label">Details</label>
                <div class="scroll-box-300 bordered-box">
                  <table class="w-100">
                    <tbody>
                      <tr class="d-flex">
                        <th class="col-12">Parents</th>
                      </tr>
                      <ng-container *ngFor="let item of parents">
                        <ng-container *ngFor="let value of item.concepts">
                          <tr class="d-flex">
                            <td class="col-12">{{value}}</td>
                          </tr>
                        </ng-container>
                      </ng-container>

                      <tr class="d-flex">
                        <th class="col-12">Children</th>
                      </tr>
                      <ng-container *ngFor="let item of children">
                        <ng-container *ngFor="let value of item.concepts">
                          <tr class="d-flex">
                            <td class="col-12">{{value}}</td>
                          </tr>
                        </ng-container>
                      </ng-container>

                      <tr class="d-flex">
                        <th class="col-12">Maps</th>
                      </tr>
                      <ng-container *ngFor="let item of maps">
                        <ng-container *ngFor="let value of item.concepts">
                          <tr class="d-flex">
                            <td class="col-12">{{value}}</td>
                          </tr>
                        </ng-container>
                      </ng-container>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-8">
                <label class="control-label">Selection</label>
                <div class="scroll-box-250">
                  <table class="table table-striped table-hover table-sm">
                    <thead>
                      <tr class="d-flex">
                        <th class="col-2">Scheme</th>
                        <th class="col-2">Code</th>
                        <th class="col-7">Name</th>
                        <th class="col-1">Children</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr class="d-flex" *ngFor="let item of selection">
                        <td class="col-2">{{item.scheme}}</td>
                        <td class="col-2">{{item.code}}</td>
                        <td class="col-7">{{item.name}}</td>
                        <td class="col-1"><span class="badge badge-success">{{getChildText(item)}}</span></td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
              <div class="form-group col-md-4" *ngIf="parents || children || maps">
                <label class="control-label">Inclusions/Exclusions</label>
                <div class="scroll-box-250 bordered-box">
                  [ CHILD INC/EXC DETAIL TREE]
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" (click)="ok()" name="selectConcept" [disabled]="selection==null || selection.length == 0">OK</button>
          <button type="button" class="btn btn-danger" (click)="cancel()" name="cancelConcept">Cancel</button>
        </div>
      </div>
    `,
    providers: [LoggerService]
})
export class ConceptSelectorComponent implements AfterViewInit {
    codeSchemes: KVP[];
    selectedCodeSchemes: number[];
    term: string;

    searchResult: SearchResult = {} as SearchResult;
    private searchSelection: CodeableConcept;
    parents: Related[];
    children: Related[];
    maps: Related[];

    selection: ConceptSelection[] = [];

    public static open(modalService: NgbModal, selection: any = null): NgbModalRef {
        const modalRef = modalService.open(ConceptSelectorComponent, {backdrop: 'static', size: 'lg'});
        if (selection)
            modalRef.componentInstance.selection = selection;
        return modalRef;
    }

    constructor(public modal: NgbModal, public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptSelectorService) {
    }

    @ViewChild('focus') focusField: ElementRef;

    ngAfterViewInit(): void {
        if (this.focusField != null)
            this.focusField.nativeElement.focus();

        this.getCodeSchemes();
    }

    getCodeSchemes() {
        this.conceptService.getCodeSchemes()
            .subscribe(
                (result) => this.codeSchemes = result,
                (error) => this.logger.error(error)
            )
    }

    search() {
        this.searchResult = null;

        this.conceptService.search(this.term, this.selectedCodeSchemes)
            .subscribe(
                (result) => this.searchResult = result,
                (error) => this.logger.error(error)
            );
    }

    select(item) {
        if (item != this.searchSelection) {
            this.searchSelection = item;
            this.getDetails(item);
        }
    }

    getDetails(item) {
        this.parents = [{concepts: ['Loading...']} as Related];
        this.children = [{concepts: ['Loading...']} as Related];
        this.maps = [{concepts: ['Loading...']} as Related];
        this.conceptService.getForwardRelated(item.id, ['has_parent'])
            .subscribe(
                (result) => this.parents = result,
                (error) => this.logger.error(error)
            );
        this.conceptService.getBackwardRelated(item.id, ['has_parent'])
            .subscribe(
                (result) => this.children = result,
                (error) => this.logger.error(error)
            );
        this.conceptService.getForwardRelated(item.id, ['is_equivalent_to', 'is_related_to'])
            .subscribe(
                (result) => this.maps = result,
                (error) => this.logger.error(error)
            );

    }

    addSelection(item, includeChildren: boolean) {
        if (this.selection.indexOf(item) == -1) {
            this.selection.push(item);
        }
    }

    getChildText(item: ConceptSelection) {
        if (!item.excludeChildren)
            return 'All';
        if (item.exclusions && item.exclusions.length > 0)
            return 'Some';
        return 'None';
    }

    ok() {
        if (this.selection) {
            this.activeModal.close(this.selection);
        }
    }

    cancel() {
        this.activeModal.dismiss();
    }
}
