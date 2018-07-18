import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptRuleset} from '../../models/ConceptRuleset';

@Component({
  selector: 'app-rule-editor',
  templateUrl: './rule-editor-dialog.component.html',
  styleUrls: ['./rule-editor-dialog.component.css']
})
export class RuleEditorDialogComponent implements OnInit {
  public static open(modalService: NgbModal, ruleset: ConceptRuleset) {
    const modalRef = modalService.open(RuleEditorDialogComponent, { backdrop: 'static', size: 'lg'});
    modalRef.componentInstance.ruleset = ruleset;
    return modalRef;
  }

  ruleset: ConceptRuleset;

  constructor(private activeModal: NgbActiveModal) { }

  ngOnInit() {
  }

  ok() {
    this.activeModal.close(this.ruleset);
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
