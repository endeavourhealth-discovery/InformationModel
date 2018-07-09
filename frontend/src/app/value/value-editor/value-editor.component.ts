import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {ValueService} from '../value.service';
import {LoggerService} from 'eds-angular4';
import {ValueSummary} from '../../models/ValueSummary';
import {Attribute} from '../../models/Attribute';

@Component({
  selector: 'app-value-editor',
  templateUrl: './value-editor.component.html',
  styleUrls: ['./value-editor.component.css']
})
export class ValueEditorComponent implements OnInit {
  value: ValueSummary;
  attributes: Attribute[];

  constructor(private route: ActivatedRoute,
              private logger: LoggerService,
              private valueService: ValueService) { }

  ngOnInit() {
    this.route.params.subscribe(
      (params) => this.loadConceptValue(params['id'])
    );
  }

  loadConceptValue(id: any) {
    this.valueService.get(id).subscribe(
      (result) => this.setValue(result),
      (error) => this.logger.error(error)
    );
  }

  setValue(value: any) {
    this.value = value;
  }

  getAttributeValue(item: Attribute) {
  }
}

