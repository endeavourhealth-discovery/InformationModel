import { Component, OnInit } from '@angular/core';
import {LoggerService} from 'eds-angular4';
import {ConceptSummary} from '../models/ConceptSummary';
import {Router} from '@angular/router';
import {TermMappingsService} from './term-mappings.service';

@Component({
  selector: 'app-term-mappings',
  templateUrl: './term-mappings.component.html',
  styleUrls: ['./term-mappings.component.css']
})
export class TermMappingsComponent implements OnInit {
  private page: number;
  models: ConceptSummary[];

  constructor(private router: Router,
              private termMappingsService: TermMappingsService,
              private log: LoggerService
  ) { }

  ngOnInit() {
    this.page = 1;
    this.getTermMappings();
  }

  getTermMappings() {
    this.termMappingsService.getSummaries(this.page)
      .subscribe(
        (result) => this.models = result,
        (error) => this.log.error(error)
      );
  }

  editTermMappings(concept: ConceptSummary) {
    this.router.navigate(['termMappings', concept.id]);
  }
}
