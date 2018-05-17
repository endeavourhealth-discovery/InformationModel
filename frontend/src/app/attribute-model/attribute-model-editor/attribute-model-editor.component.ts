import {AfterViewInit, Component, OnInit} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptPickerComponent} from '../../concept/concept-picker/concept-picker.component';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../../concept/concept.service';
import {Location} from '@angular/common';

@Component({
  selector: 'app-attribute-model-editor',
  templateUrl: './attribute-model-editor.component.html',
  styleUrls: [
    './attribute-model-editor.component.css',
  ]
})
export class AttributeModelEditorComponent implements AfterViewInit {
  model: Concept;
  data: any;
  selectedRelation: any;

  // Local enum instance
  ConceptStatus = ConceptStatus;

  constructor(private route: ActivatedRoute,
              private location: Location,
              private logger: LoggerService,
              private modal: NgbModal,
              private conceptService: ConceptService) { }

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
  }

  getRelated() {
    this.data = {

      'nodes': [
        {'name': 'Patient Demographics', 'group': 1},

        {'name': 'Forename', 'group': 2},
        {'name': 'Surname', 'group': 2},
        {'name': 'Birth Date', 'group': 2},
        {'name': 'Address', 'group': 2},

        {'name': 'Record type', 'group': 3}
      ],
      'edges': [
        {'source': 0, 'target': 1, 'label': 'Has a'},
        {'source': 0, 'target': 2, 'label': 'Has a'},
        {'source': 0, 'target': 3, 'label': 'Has a'},
        {'source': 0, 'target': 4, 'label': 'Has a'},
        {'source': 0, 'target': 5, 'label': 'Is a'}
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
