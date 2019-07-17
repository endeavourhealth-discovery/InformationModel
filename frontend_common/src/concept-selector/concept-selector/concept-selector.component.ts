import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal, NgbModalRef} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptSelectorService} from '../concept-selector.service';
import {KVP} from '../../models/KVP';
import {CodeableConcept} from '../../models/CodeableConcept';
import {ConceptSelection} from '../../models/ConceptSelection';
import {SearchResult} from '../../models/SearchResult';
import {Related} from '../../models/Related';
import {CodeSet} from '../../models/CodeSet';

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
                          <th class="col-6">Name</th>
                          <th class="col-2"></th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr class="d-flex show-child-on-hover" *ngFor="let item of searchResult?.results" (click)="highlightSearch(item)" [class.selection]="searchHighlight==item"
                            [class.text-warning]="item.status == 2">
                          <td class="col-2">{{item.scheme}}</td>
                          <td class="col-2">{{item.code}}</td>
                          <td class="col-6">{{item.name}}</td>
                          <td class="col-2">
                            <div class="pull-right child-to-show">
                              <button class="btn btn-xs btn-success" (click)="include(item)">Inc</button>
                              <button class="btn btn-xs btn-danger" (click)="exclude(item)">Exc</button>
                            </div>
                          </td>
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
                      <tr class="d-flex" *ngIf="parents && parents.length > 0">
                        <th class="col-12">Parents</th>
                      </tr>
                      <ng-container *ngFor="let item of parents">
                        <ng-container *ngFor="let value of item.concepts">
                          <tr class="d-flex" (click)="viewRelated(value)">
                            <td class="col-12">{{value.name}}</td>
                          </tr>
                        </ng-container>
                      </ng-container>

                      <tr class="d-flex" *ngIf="children && children.length > 0">
                        <th class="col-12">Children</th>
                      </tr>
                      <ng-container *ngFor="let item of children">
                        <ng-container *ngFor="let value of item.concepts">
                          <tr class="d-flex" (click)="viewRelated(value)">
                            <td class="col-12">{{value.name}}</td>
                          </tr>
                        </ng-container>
                      </ng-container>

                      <tr class="d-flex" *ngIf="maps && maps.length > 0">
                        <th class="col-12">Maps</th>
                      </tr>
                      <ng-container *ngFor="let item of maps">
                        <ng-container *ngFor="let value of item.concepts">
                          <tr class="d-flex" (click)="viewRelated(value)">
                            <td class="col-12">{{value.name}}</td>
                          </tr>
                        </ng-container>
                      </ng-container>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="form-group col-md-6">
                <label class="control-label">Inclusions</label>
                <div class="scroll-box-250">
                  <table class="table table-striped table-hover table-sm">
                    <thead>
                      <tr class="d-flex">
                        <th class="col-2">Scheme</th>
                        <th class="col-2">Code</th>
                        <th class="col-6">Name</th>
                        <th class="col-2">+ Children</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr class="d-flex" *ngFor="let item of inclusions" [class.selection]="selectionHighlight==item">
                        <td class="col-2">{{item.scheme}}</td>
                        <td class="col-2">{{item.code}}</td>
                        <td class="col-6">{{item.name}}</td>
                        <td class="col-2">{{getChildText(item)}}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
              <div class="form-group col-md-6">
                <label class="control-label">Exclusions</label>
                <div class="scroll-box-250">
                  <table class="table table-striped table-hover table-sm">
                    <thead>
                      <tr class="d-flex">
                        <th class="col-2">Scheme</th>
                        <th class="col-2">Code</th>
                        <th class="col-6">Name</th>
                        <th class="col-2">+ Children</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr class="d-flex" *ngFor="let item of exclusions" [class.selection]="selectionHighlight==item">
                        <td class="col-2">{{item.scheme}}</td>
                        <td class="col-2">{{item.code}}</td>
                        <td class="col-6">{{item.name}}</td>
                        <td class="col-2">{{getChildText(item)}}</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" (click)="ok()" name="selectConcept" [disabled]="inclusions==null || inclusions.length == 0">OK</button>
          <button type="button" class="btn btn-danger" (click)="cancel()" name="cancelConcept">Cancel</button>
        </div>
      </div>
    `,
    providers: [LoggerService]
})
export class ConceptSelectorComponent implements AfterViewInit {
    @ViewChild('focus') focusField: ElementRef;

    codeSchemes: KVP[];
    selectedCodeSchemes: number[];
    term: string;

    searchResult: SearchResult = {} as SearchResult;
    parents: Related[];
    children: Related[];
    maps: Related[];

    inclusions: ConceptSelection[] = [];
    exclusions: ConceptSelection[] = [];

    private searchHighlight: CodeableConcept;
    private selectionHighlight: ConceptSelection;


    public static open(modalService: NgbModal, selection: CodeSet = null): NgbModalRef {
        const modalRef = modalService.open(ConceptSelectorComponent, {backdrop: 'static', size: 'lg'});
        if (selection) {
            if (selection.inclusions)
                modalRef.componentInstance.inclusions = selection.inclusions;
            if (selection.exclusions)
                modalRef.componentInstance.exclusions = selection.exclusions;
        }
        return modalRef;
    }

    constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptSelectorService) {
    }

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

    highlightSearch(item: CodeableConcept) {
        if (item != this.searchHighlight) {
            this.searchHighlight = item;
            this.getDetails(item);
        }
    }

    getDetails(item: CodeableConcept) {
        this.parents = [{concepts: [{name: 'Loading...'}]} as Related];
        this.children = [{concepts: [{name: 'Loading...'}]} as Related];
        this.maps = [{concepts: [{name: 'Loading...'}]} as Related];
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

    viewRelated(item: CodeableConcept) {
        this.searchResult.results = [item];
        this.getDetails(item);
    }

    include(item: CodeableConcept) {
        if (this.inclusions.findIndex(i => i.id === item.id) == -1) {
            this.inclusions.push({
                id: item.id,
                name: item.name,
                scheme: item.scheme,
                code: item.code
            } as ConceptSelection);
        }
    }

    exclude(item: CodeableConcept) {
        if (this.exclusions.findIndex(i => i.id === item.id) == -1) {
            this.exclusions.push({
                id: item.id,
                name: item.name,
                scheme: item.scheme,
                code: item.code
            } as ConceptSelection);
        }
    }

    getChildText(item: ConceptSelection) {
        return item.single ? 'No' : 'Yes';
    }

    ok() {
        if (this.inclusions) {
            this.activeModal.close({
                inclusions: this.inclusions,
                exclusions: this.exclusions
            });
        }
    }

    cancel() {
        this.activeModal.dismiss();
    }
}
