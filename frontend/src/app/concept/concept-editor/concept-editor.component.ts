import {AfterViewInit, Component} from '@angular/core';
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
  nodemap: any = {};

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
    this.loadDetails(concept.id, 0);
  }

  loadDetails(conceptId: number, nodeIndex: number) {

    forkJoin(
        this.conceptService.getRelatedTargets(conceptId),
        this.conceptService.getRelatedSources(conceptId),
        this.conceptService.getAttributes(conceptId)
    )
      .subscribe(
        ([targets, sources, attributes]) => this.extendData(nodeIndex, targets, sources, attributes),
        (error) => this.logger.error(error)
      );
  }

  extendData(nodeIndex: number, targets: RelatedConcept[], sources: RelatedConcept[], attributes: ConceptSummary[]) {
    for (let target of targets) {
      let i = this.nodemap[target.id];
      if (!i) {
        i = this.nodes.push({name: target.context, group: 2, data: target});
        this.nodemap[target.id] = i;
      }
      this.edges.push({source: nodeIndex, target: i - 1, label: target.relationship});
    }
    for (let source of sources) {
      let i = this.nodemap[source.id];
      if (!i) {
        i = this.nodes.push({name: source.context, group: 3, data: source});
        this.nodemap[source.id] = i;
      }
      this.edges.push({source: i - 1, target: nodeIndex, label: source.relationship});
    }
    for (let attribute of attributes) {
      let i = this.nodemap[attribute.id];
      if (!i) {
        i = this.nodes.push({name: attribute.context, group: 4, data: attribute});
        this.nodemap[attribute.id] = i;
      }
      this.edges.push({source: nodeIndex, target: i - 1, label: 'Attribute'});
    }

    this.buildDiagram();
  }

  buildDiagram() {
    let tempData = {nodes: [], edges: []};

    for (let node of this.nodes) {
      tempData.nodes.push(Object.assign({}, node));
    }

    for (let edge of this.edges) {
      tempData.edges.push(Object.assign({}, edge));
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

  nodeClick(node) {
    console.log("Click");
    console.log(node);

  }

  nodeDblClick(node) {
    console.log("Double Click");
    console.log(node);
    if (!node.data.loaded) {
      node.data.loaded = true;
      this.loadDetails(node.data.id, node.index);
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
