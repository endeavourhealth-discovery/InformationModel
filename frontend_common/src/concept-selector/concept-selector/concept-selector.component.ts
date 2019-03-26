import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal, NgbModalRef} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptSelectorService} from '../concept-selector.service';

@Component({
    selector: 'app-concept-selector',
    template: `
      <div [hidden]="hide">
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
                  <input class="form-control" type="text" [(ngModel)]="criteria" name="filter" #focus autofocus (keyup.enter)="search()">
                  <div class="input-group-append">
                    <button class="input-group-text" (click)="search()"><i class="fa fa-search"></i></button>
                  </div>
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
                          <th class="col-2">Id</th>
                          <th class="col-2">Name</th>
                          <th class="col-8">Description</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr class="d-flex" *ngFor="let item of result" (click)="selection=item" (dblclick)="ok()" [class.selection]="selection==item" [class.text-warning]="item.status == 2">
                          <td class="col-2">{{item.id}}</td>
                          <td class="col-2">{{item.name}}</td>
                          <td class="col-8">{{item.description}}</td>
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
          <button type="button" class="btn btn-success" (click)="ok()" name="selectConcept" [disabled]="selection==null">Select</button>
          <button type="button" class="btn btn-danger" (click)="cancel()" name="cancelConcept">Cancel</button>
        </div>
      </div>
    `,
    providers: [LoggerService]
})
export class ConceptSelectorComponent implements AfterViewInit {
    hide: boolean;
    criteria: string;
    selection: any;
    relationship: string;
    target: string;
    result: any;

    public static open(modalService: NgbModal, selection: any = null, relationship: string = null, target: string = null): NgbModalRef {
        const modalRef = modalService.open(ConceptSelectorComponent, {backdrop: 'static', size: 'lg'});
        modalRef.componentInstance.selection = selection;
        modalRef.componentInstance.relationship = relationship;
        modalRef.componentInstance.target = target;
        return modalRef;
    }

    constructor(public modal: NgbModal, public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptSelectorService) {
    }

    @ViewChild('focus') focusField: ElementRef;
    ngAfterViewInit(): void {
        if (this.focusField != null)
            this.focusField.nativeElement.focus();

        this.getMRU();
    }

    getMRU() {
        this.conceptService.getMRU()
            .subscribe(
                (result) => this.result = result,
                (error) => this.logger.error(error)
            );
    }

    search() {
        this.result = null;

        this.conceptService.search(this.criteria, this.relationship, this.target)
            .subscribe(
                (result) => this.result = result,
                (error) => this.logger.error(error)
            );
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
