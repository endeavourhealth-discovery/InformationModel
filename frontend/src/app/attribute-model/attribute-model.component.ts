import { Component, OnInit } from '@angular/core';
import {LoggerService} from 'eds-angular4';
import {ConceptSummary} from '../models/ConceptSummary';
import {Router} from '@angular/router';
import {AttributeModelService} from './attribute-model.service';
import {AttributeModelSummary} from '../models/AttributeModelSummary';

@Component({
  selector: 'app-attribute-model',
  templateUrl: './attribute-model.component.html',
  styleUrls: ['./attribute-model.component.css']
})
export class AttributeModelComponent implements OnInit {
  private page: number;
  models: AttributeModelSummary[];

  constructor(private router: Router,
              private attributeModelService: AttributeModelService,
              private log: LoggerService
  ) { }

  ngOnInit() {
    this.page = 1;
    this.getAttributeModels();
  }

  getAttributeModels() {
    this.attributeModelService.getSummaries(this.page)
      .subscribe(
        (result) => this.models = result,
        (error) => this.log.error(error)
      );
  }

  editAttributeModel(concept: ConceptSummary) {
    this.router.navigate(['attributeModel', concept.id]);
  }
}
