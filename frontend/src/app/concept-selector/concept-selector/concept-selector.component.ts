import { Component, OnInit } from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ConceptSummary} from '../../models/ConceptSummary';
import {ConceptSelectorService} from '../concept-selector.service';
import {IdText} from '../../models/IdText';

@Component({
  selector: 'app-concept-selector',
  templateUrl: './concept-selector.component.html',
  styleUrls: ['./concept-selector.component.css']
})
export class ConceptSelectorComponent implements OnInit {
  systems: IdText[];
  selectedSystems: number[];
  criteria: string;
  activeOnly: boolean = true;
  selection: ConceptSummary;
  result: ConceptSummary[] = [];

  public static open(modalService: NgbModal) {
    const modalRef = modalService.open(ConceptSelectorComponent, { backdrop: 'static'});
    return modalRef;
  }

  constructor(public activeModal: NgbActiveModal, private logger: LoggerService, private conceptService: ConceptSelectorService) { }

  ngOnInit() {
    this.loadSystems();
  }

  loadSystems() {
    this.conceptService.getCodeSystems().subscribe(
      (result) => {
        this.systems = result;
        this.selectedSystems = this.systems.map(s => s.id);
      },
      (error) => this.logger.error(error)
    );
  }

  search() {
    this.result = null;
    const codeSystems = (this.selectedSystems.length === this.systems.length) ? null : this.selectedSystems;

    this.conceptService.search(this.criteria, this.activeOnly, codeSystems)
      .subscribe(
        (result) => this.result = result.concepts,
        (error) => this.logger.error(error)
      );
  }

  ok() {
    this.conceptService.getConcept(this.selection.id)
      .subscribe(
        (result) => this.activeModal.close(result),
        (error) => this.logger.error(error)
      );
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
