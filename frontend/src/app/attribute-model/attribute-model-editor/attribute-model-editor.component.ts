import {AfterViewInit, Component, OnInit} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptPickerComponent} from '../../concept/concept-picker/concept-picker.component';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../../concept/concept.service';
import {Location} from '@angular/common';
import {forkJoin} from 'rxjs/observable/forkJoin';
import {AttributeModelService} from '../attribute-model.service';

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
              private conceptService: ConceptService,
              private attributeService: AttributeModelService) { }

  ngAfterViewInit() {
    this.route.params.subscribe(
      params => {
        this.loadAttributeModel(params['id']);
      });
  }

  loadAttributeModel(id: number) {
    this.conceptService.getConcept(id)
      .subscribe(
        (result) => this.loadDetails(result),
        (error) => this.logger.error(error)
      );
  }

  loadDetails(concept: Concept) {
    this.model = concept;

    forkJoin([
        this.conceptService.getRelatedTargets(this.model.id),
        this.conceptService.getRelatedSources(this.model.id),
        // this.attributeService.getAttributes(this.model.id)
    ])
      .subscribe(
        (results) => this.buildRelated(results),
        (error) => this.logger.error(error)
      );
  }

  buildRelated(results:any[]) {
    const targets = results[0];
    const sources = results[1];
    const attributes = results[2];

    let tempData = {nodes: [{name: this.model.context, group: 1}], edges: []};

    for(let target of targets) {
      let i = tempData.nodes.push({name: target.context, group: 2});
      tempData.edges.push({source: 0, target: i-1, label: 'Has target'});
    }
    for(let source of sources) {
      let i = tempData.nodes.push({name: source.context, group: 3});
      tempData.edges.push({source: i-1, target: 0, label: 'Has source'});
    }
    for(let attribute of attributes) {
      let i = tempData.nodes.push({name: attribute.context, group: 4});
      tempData.edges.push({source: 0, target: i-1, label: 'Has attribute'});
    }

    this.data = tempData;
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
