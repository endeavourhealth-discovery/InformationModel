import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptPickerComponent} from '../concept-picker/concept-picker.component';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../concept.service';
import {Location} from '@angular/common';
import {forkJoin} from 'rxjs/observable/forkJoin';
import {RelatedConcept} from '../../models/RelatedConcept';
import {ConceptSummary} from '../../models/ConceptSummary';
import {NodeGraphComponent} from '../../node-graph/node-graph/node-graph.component';

@Component({
  selector: 'app-concept-editor',
  templateUrl: './concept-editor.component.html',
  styleUrls: [
    './concept-editor.component.css',
  ]
})
export class ConceptEditorComponent implements AfterViewInit {
  model: Concept;
  data: any;
  selectedRelation: any;
  nodes: any[];
  edges: any[];

  @ViewChild('nodeGraph') graph: NodeGraphComponent;

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
        this.loadConcept(params['id']);
      });
  }

  loadConcept(id: number) {
    this.conceptService.getConcept(id)
      .subscribe(
        (result) => this.setConcept(result),
        (error) => this.logger.error(error)
      );
  }

  setConcept(concept: Concept) {
    this.model = concept;
    this.data = null;
    this.nodes = [{name: this.model.context, group: 1}];
    this.edges = [];
    this.graph.addNodeData(concept.id, concept.context, 1, concept);
    this.loadDetails(concept.id);
  }

  loadDetails(conceptId: number) {

    forkJoin(
        this.conceptService.getRelatedTargets(conceptId),
        this.conceptService.getRelatedSources(conceptId),
        this.conceptService.getAttributes(conceptId),
        this.conceptService.getAttributeOf(conceptId)
    )
      .subscribe(
        ([targets, sources, attributes, attributeOf]) => this.extendData(conceptId, targets, sources, attributes, attributeOf),
        (error) => this.logger.error(error)
      );
  }

  extendData(conceptId: number, targets: RelatedConcept[], sources: RelatedConcept[], attributes: ConceptSummary[], attributeOf: ConceptSummary[]) {
    for (let target of targets) {
      this.graph.addNodeData(target.id, target.context, 2, target);
      this.graph.addEdgeData(conceptId, target.id, target.relationship);
    }
    for (let source of sources) {
      this.graph.addNodeData(source.id, source.context, 2, source);
      this.graph.addEdgeData(source.id, conceptId, source.relationship);
    }
    for (let attribute of attributes) {
      this.graph.addNodeData(attribute.id, attribute.context, 3, attribute);
      this.graph.addEdgeData(conceptId, attribute.id, 'Has attribute');
    }
    for (let concept of attributeOf) {
      this.graph.addNodeData(concept.id, concept.context, 2, concept);
      this.graph.addEdgeData(concept.id, conceptId, 'Has attribute');
    }
    this.graph.start();
  }

  getConceptStatusName(status: ConceptStatus): string {
    return ConceptStatusHelper.getName(status);
  }

  setStatus(status: ConceptStatus) {
    this.model.status = status;
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

  nodeClick(node) {
    console.log("Click");
    console.log(node);
  }

  nodeDblClick(node) {
    console.log("Double Click");
    console.log(node);
    if (!node.data.loaded) {
      node.data.loaded = true;
      this.loadDetails(node.data.id);
    }
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
