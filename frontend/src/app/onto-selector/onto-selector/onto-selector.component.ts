import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal, NgbModalRef} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {OntoSelectorService} from '../onto-selector.service';

@Component({
    selector: 'app-onto-selector',
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
                  <div class="scroll-box-350" *ngIf="result">
                    <table class="table table-striped table-hover table-sm">
                      <thead>
                        <tr class="d-flex">
                          <th class="col-2">Id</th>
                          <th class="col-2">Name</th>
                          <th class="col-8">Description</th>
                        </tr>
                      </thead>
                      <tbody>
                        <ng-container *ngFor="let item of result.expansion.contains">
                          <tr class="d-flex" [class.text-warning]="isInactive(item)" (click)="selection=item" (dblclick)="ok()" [class.selection]="selection==item">
                            <td class="col-2">{{item.code}}</td>
                            <td class="col-2">{{item.system}}</td>
                            <td class="col-8">{{item.display}}</td>
                          </tr>
                        </ng-container>
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
export class OntoSelectorComponent implements AfterViewInit {
    hide: boolean;
    criteria: string;
    selection: any;
    relationship: string;
    target: string;
    result: any;

    public static open(modalService: NgbModal, selection: any = null, relationship: string = null, target: string = null): NgbModalRef {
        const modalRef = modalService.open(OntoSelectorComponent, {backdrop: 'static', size: 'lg'});
        modalRef.componentInstance.selection = selection;
        modalRef.componentInstance.relationship = relationship;
        modalRef.componentInstance.target = target;
        return modalRef;
    }

    constructor(public modal: NgbModal, public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: OntoSelectorService) {
    }

    @ViewChild('focus') focusField: ElementRef;
    ngAfterViewInit(): void {
        if (this.focusField != null)
            this.focusField.nativeElement.focus();

    }

    search() {
        this.result = null;

        this.conceptService.search(this.criteria)
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

  isInactive(item:any) {
      if (!item.extension)
        return false;

      if (!item.extension)
        return false;

      if (item.extension.length === 0)
        return false;

      if (!item.extension[0].extension)
        return false;

      if (item.extension[0].extension[0].url !== 'inactive')
        return false;

      return item.extension[0].extension[0].valueBoolean;
  }
}
