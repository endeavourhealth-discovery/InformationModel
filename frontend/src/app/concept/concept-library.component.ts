import { Component, OnInit } from '@angular/core';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {Router} from '@angular/router';
import {ConceptService} from './concept.service';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Concept} from '../models/Concept';
import {ConceptStatusHelper} from '../models/ConceptStatus';
import {SearchResult} from 'im-common/dist/models/SearchResult';

@Component({
  selector: 'app-concept-library',
  templateUrl: './concept-library.component.html',
  styleUrls: ['./concept-library.component.css']
})
export class ConceptLibraryComponent implements OnInit {
  getStatusName = ConceptStatusHelper.getName;

  listTitle = 'Most recently used';
  summaryList: SearchResult;
  searchTerm: string;
  includeDeprecated = false;

  constructor(private router: Router,
              private modal: NgbModal,
              private conceptService: ConceptService,
              private log: LoggerService
  ) { }

  ngOnInit() {
    this.getMRU();
  }

  getMRU() {
    this.summaryList = null;
    this.conceptService.getMRU(this.includeDeprecated)
      .subscribe(
        (result) => this.summaryList = result,
        (error) => this.log.error(error)
      );
  }

  search() {
    this.listTitle = 'Search results for "' + this.searchTerm + '"';
    this.summaryList = null;
    this.conceptService.search(this.searchTerm, this.includeDeprecated)
      .subscribe(
        (result) => this.summaryList = result,
        (error) => this.log.error(error)
      );
  }

  toggleDeprecated() {
    // this.includeDeprecated = !this.includeDeprecated;
    if (this.searchTerm)
      this.search();
    else
      this.getMRU();
  }

  clear() {
    this.listTitle = 'Most recently used';
    this.searchTerm = '';
    this.getMRU();
  }

  editConcept(concept: Concept) {
    this.router.navigate(['concept', concept.id])
  }

  addConcept() {
      InputBoxDialog.open(this.modal, 'Add concept', 'Enter context name for the new concept', '', 'OK', 'Cancel')
        .result.then(
        (result) => this.router.navigate(['concept', 'add', result])
      );
  }

  gotoPage(page) {
    this.listTitle = 'Search results for "' + this.searchTerm + '"';
    this.summaryList = null;
    this.conceptService.search(this.searchTerm, this.includeDeprecated, page)
      .subscribe(
        (result) => this.summaryList = result,
        (error) => this.log.error(error)
      );
  }
}
