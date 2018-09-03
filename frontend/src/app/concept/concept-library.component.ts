import { Component, OnInit } from '@angular/core';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {ConceptSummary} from '../models/ConceptSummary';
import {Router} from '@angular/router';
import {ConceptService} from './concept.service';
import {ConceptSummaryList} from '../models/ConceptSummaryList';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptSelectorComponent} from '../concept-selector/concept-selector/concept-selector.component';

@Component({
  selector: 'app-concept-library',
  templateUrl: './concept-library.component.html',
  styleUrls: ['./concept-library.component.css']
})
export class ConceptLibraryComponent implements OnInit {
  listTitle: string = 'Most recently used';
  summaryList: ConceptSummaryList
  searchTerm: string;
  activeOnly: boolean = true;

  constructor(private router: Router,
              private modal: NgbModal,
              private conceptService: ConceptService,
              private log: LoggerService
  ) { }

  ngOnInit() {
    this.getMRU();
  }

  getMRU() {
    this.conceptService.getMRU(this.activeOnly)
      .subscribe(
        (result) => this.summaryList = result,
        (error) => this.log.error(error)
      );
  }

  editConcept(concept: ConceptSummary) {
    this.router.navigate(['concept', concept.id]);
  }

  search() {
    this.listTitle = 'Search results for "' + this.searchTerm + '"';
    this.summaryList = null;
    this.conceptService.search(this.searchTerm, this.activeOnly)
      .subscribe(
        (result) => this.summaryList = result,
        (error) => this.log.error(error)
      );
  }

  clear() {
    this.listTitle = 'Most recently used';
    this.searchTerm = '';
    this.getMRU();
  }

  addConcept() {
      InputBoxDialog.open(this.modal, 'Add concept', 'Enter context name for the new concept', '', 'OK', 'Cancel')
        .result.then(
        (result) => this.router.navigate(['concept', 'add', result])
      );
  }

  showConceptPicker() {
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (result) => console.log(result)
    );
  }
}
