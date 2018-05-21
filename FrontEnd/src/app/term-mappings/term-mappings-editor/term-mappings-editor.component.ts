import {AfterViewInit, Component, OnInit} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptPickerComponent} from '../../concept/concept-picker/concept-picker.component';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../../concept/concept.service';
import {Location} from '@angular/common';
import {TermMappingsService} from '../term-mappings.service';
import {TermMapping} from '../../models/TermMapping';

@Component({
  selector: 'app-attribute-model-editor',
  templateUrl: './term-mappings-editor.component.html',
  styleUrls: [
    './term-mappings-editor.component.css',
  ]
})
export class TermMappingsEditorComponent implements AfterViewInit {
  model: Concept;
  maps: TermMapping[];
  data: any;
  selectedRelation: any;

  // Local enum instance
  ConceptStatus = ConceptStatus;

  constructor(private route: ActivatedRoute,
              private location: Location,
              private logger: LoggerService,
              private modal: NgbModal,
              private conceptService: ConceptService,
              private termService: TermMappingsService) { }

  ngAfterViewInit() {
    this.route.params.subscribe(
      params => {
        this.loadAttributeModel(params['id']);
      });
  }

  loadAttributeModel(id: number) {
    this.conceptService.getConcept(id)
      .subscribe(
        (result) => { this.model = result; this.getRelated() },
        (error) => this.logger.error(error)
      );
    this.termService.getMappings(id)
      .subscribe(
        (result) => this.maps = result,
        (error) => this.logger.error(error)
      );
  }

  getRelated() {
    this.data = {

      'nodes': [
        {'name': 'Term', 'group': 1},

        {'name': 'Child Term 1', 'group': 2},
        {'name': 'Child Term 2', 'group': 2},
        {'name': 'Child Term 3', 'group': 2},
        {'name': 'Child Term 4', 'group': 2},

        {'name': 'Term Parent', 'group': 3}
      ],
      'edges': [
        {'source': 0, 'target': 1, 'label': 'Has child'},
        {'source': 0, 'target': 2, 'label': 'Has child'},
        {'source': 0, 'target': 3, 'label': 'Has child'},
        {'source': 0, 'target': 4, 'label': 'Has child'},
        {'source': 0, 'target': 5, 'label': 'Has parent'}
      ]
    };
  }

  getConceptStatusName(status: ConceptStatus): string {
    return ConceptStatusHelper.getName(status);
  }

  setStatus(status: ConceptStatus) {
    this.model.status = status;
  }

  selectRelated(node: any) {
    this.selectedRelation = node;
  }

  addRelationship() {
    ConceptPickerComponent.open(this.modal).result
      .then(
        (result) => this.processRelationship(result),
        (error) => this.logger.error(error)
      );
  }

  processRelationship(concept: Concept) {
    if (concept.id == null) {
      this.promptNewConceptContext(concept);
    } else {
      this.addRelatedConcept(concept);
    }
  }

  promptNewConceptContext(concept: Concept) {
    let contextName = concept.context;
    if (contextName.substring(0, this.model.context.length) !== this.model.context) {
      contextName = this.model.context + '.' + contextName;
    }

    InputBoxDialog.open(this.modal, 'Create new concept', 'Create a new concept with the context name', contextName)
      .result.then(
      (result) => { concept.context = result; this.createAndAddRelatedConcept(concept); },
      (error) => this.logger.error(error )
    );
  }

  createAndAddRelatedConcept(concept: Concept) {
    this.conceptService.save(concept)
      .subscribe(
        (result) => { concept.id = result; this.addRelatedConcept(concept); },
        (error) => this.logger.error(error)
      );
  }

  addRelatedConcept(concept: Concept) {
    this.logger.info('Add related', concept, 'Add related');
  }

  save() {
    this.conceptService.save(this.model)
      .subscribe(
        (result) => this.close(false),
        (error) => this.logger.error('Error during save', error, 'Save')
      );
  }

  close(withConfirm: boolean) {
    this.location.back();
  }
}
