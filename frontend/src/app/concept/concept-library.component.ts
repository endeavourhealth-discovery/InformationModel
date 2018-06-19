import { Component, OnInit } from '@angular/core';
import {LoggerService} from 'eds-angular4';
import {ConceptSummary} from '../models/ConceptSummary';
import {Router} from '@angular/router';
import {ConceptService} from './concept.service';
import {ConceptSummaryList} from '../models/ConceptSummaryList';

@Component({
  selector: 'app-concept-library',
  templateUrl: './concept-library.component.html',
  styleUrls: ['./concept-library.component.css']
})
export class ConceptLibraryComponent implements OnInit {
  listTitle: string = 'Most recently used';
  summaryList: ConceptSummaryList
  searchTerm: string;

  constructor(private router: Router,
              private conceptService: ConceptService,
              private log: LoggerService
  ) { }

  ngOnInit() {
    this.getMRU();
  }

  getMRU() {
    this.conceptService.getMRU()
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
    this.conceptService.search(this.searchTerm)
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
}
