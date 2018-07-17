import {Component, Input} from '@angular/core';
import {NgbActiveModal, NgbModal, NgbModalRef} from '@ng-bootstrap/ng-bootstrap';
import {CalculationResult} from '../../models/CalculationResult';

@Component({
  selector: 'app-test-result-dialog',
  templateUrl: './test-result-dialog.component.html',
  styleUrls: ['./test-result-dialog.component.css']
})
export class TestResultDialogComponent {

  public static open(modalService: NgbModal,
                     result: any) : NgbModalRef {
    const modalRef = modalService.open(TestResultDialogComponent, {backdrop: "static", size: "lg"});
    modalRef.componentInstance.result = result;
    return modalRef;
  }

  @Input() result: CalculationResult;

  constructor(public activeModal: NgbActiveModal) { }

  getStatusString(): string {
    switch (this.result.status) {
      case 0: return 'Concept found';
      case 1: return 'Unmatched concept';
    }
  }

  getStackTraceString(): string {
    return JSON.stringify(this.result.stackTrace, null, 2);
  }

  getConceptString(): string {
    return JSON.stringify(this.result.result, null, 2);
  }
}
