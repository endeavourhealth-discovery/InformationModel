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
import {ConceptSummary} from '../../models/ConceptSummary';
import {forkJoin} from 'rxjs/observable/forkJoin';

@Component({
  selector: 'app-term-mappings-editor',
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
        this.loadConcept(params['id']);
      });
  }

  loadConcept(id: number) {
    // this.model = null;
    // this.maps = null;
    // this.data = null;
    this.conceptService.getConcept(id)
      .subscribe(
        (result) => this.loadDetails(result),
        (error) => this.logger.error(error)
      );
  }

  loadDetails(concept: Concept) {
    this.model = concept;
    this.termService.getMappings(this.model.id)
      .subscribe(
        (result) => this.maps = result,
        (error) => this.logger.error(error)
      );

    forkJoin([this.conceptService.getRelatedTargets(this.model.id), this.conceptService.getRelatedSources(this.model.id)])
      .subscribe(
        (results) => this.buildRelated(results),
        (error) => this.logger.error(error)
      );
  }

  buildRelated(results:any[]) {
    const targets = results[0];
    const sources = results[1];

    let tempData = {nodes: [{name: this.model.context, group: 1}], edges: []};

    for(let target of targets) {
      let i = tempData.nodes.push({name: target.context, group: 2});
      tempData.edges.push({source: 0, target: i-1, label: 'Has target'});
    }
    for(let source of sources) {
      let i = tempData.nodes.push({name: source.context, group: 3});
      tempData.edges.push({source: i-1, target: 0, label: 'Has source'});
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
