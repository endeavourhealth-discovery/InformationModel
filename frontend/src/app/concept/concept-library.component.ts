import { Component, OnInit } from '@angular/core';
import {LoggerService} from 'eds-angular4';
import {ConceptSummary} from '../models/ConceptSummary';
import {Router} from '@angular/router';
import {ConceptService} from './concept.service';

@Component({
  selector: 'app-concept-library',
  templateUrl: './concept-library.component.html',
  styleUrls: ['./concept-library.component.css']
})
export class ConceptLibraryComponent implements OnInit {
  private page: number;
  concepts: ConceptSummary[];

  constructor(private router: Router,
              private conceptService: ConceptService,
              private log: LoggerService
  ) { }

  ngOnInit() {
    this.page = 1;
    this.getConcepts();
  }

  getConcepts() {
    this.conceptService.getSummaries(this.page)
      .subscribe(
        (result) => this.concepts = result,
        (error) => this.log.error(error)
      );
  }

  editConcept(concept: ConceptSummary) {
    this.router.navigate(['concept', concept.id]);
  }
}
