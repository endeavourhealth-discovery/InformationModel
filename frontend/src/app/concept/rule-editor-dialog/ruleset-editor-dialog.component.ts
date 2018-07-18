import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptRuleset} from '../../models/ConceptRuleset';
import {ConceptRule} from '../../models/ConceptRule';
import {ConceptPickerComponent} from '../concept-picker/concept-picker.component';

@Component({
  selector: 'app-rule-editor',
  templateUrl: './ruleset-editor-dialog.component.html',
  styleUrls: ['./ruleset-editor-dialog.component.css']
})
export class RulesetEditorDialogComponent implements OnInit {
  public static open(modalService: NgbModal, ruleset: ConceptRuleset) {
    const modalRef = modalService.open(RulesetEditorDialogComponent, { backdrop: 'static', size: 'lg'});
    // TODO: Make a copy of the ruleset!!
    modalRef.componentInstance.ruleset = ruleset;
    return modalRef;
  }

  ruleset: ConceptRuleset;
  selectedRule: ConceptRule;

  constructor(private modal: NgbModal, private activeModal: NgbActiveModal) { }

  ngOnInit() {
  }

  newRule() {
    this.selectedRule = {property: '<attribute>', comparator: '=', value: '<value>'};
    this.ruleset.rules.push(this.selectedRule);
  }

  deleteRule(rule: ConceptRule) {
    let idx = this.ruleset.rules.indexOf(rule);
    if (idx > -1) {
      this.ruleset.rules.splice(idx, 1);
      if (this.selectedRule == rule)
        this.selectedRule = null;
    }
  }

  selectTarget() {
    ConceptPickerComponent.open(this.modal, false)
      .result.then();
  }

  ok() {
    this.activeModal.close(this.ruleset);
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
