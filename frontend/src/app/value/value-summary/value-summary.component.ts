import { Component, OnInit } from '@angular/core';
import {ValueService} from '../value.service';
import {ValueSummaryList} from '../../models/ValueSummaryList';
import {LoggerService} from 'eds-angular4';
import {ValueSummary} from '../../models/ValueSummary';
import {Router} from '@angular/router';

@Component({
  selector: 'app-value-summary',
  templateUrl: './value-summary.component.html',
  styleUrls: ['./value-summary.component.css']
})
export class ValueSummaryComponent implements OnInit {
  summaryList: ValueSummaryList;
  searchTerm: string;

  constructor(
    private router: Router,
    private log: LoggerService,
    private valueService: ValueService) { }

  ngOnInit() {
    this.getMRU();
  }

  getMRU() {
    this.valueService.getMRU()
      .subscribe(
        (result) => this.summaryList = result,
        (error) => this.log.error(error)
      );
  }

  addConceptValue() {

  }

  editConceptValue(item: ValueSummary) {
    this.router.navigate(['value', item.id]);
  }
}
