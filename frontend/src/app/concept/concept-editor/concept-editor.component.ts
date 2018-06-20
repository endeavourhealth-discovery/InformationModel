import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {LoggerService} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptPickerComponent} from '../concept-picker/concept-picker.component';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../concept.service';
import {Location} from '@angular/common';
import {RelatedConcept} from '../../models/RelatedConcept';
import {ConceptSummary} from '../../models/ConceptSummary';
import {NodeGraphComponent} from '../../node-graph/node-graph/node-graph.component';
import {EditRelatedComponent} from '../edit-related/edit-related.component';
import {Attribute} from '../../models/Attribute';
import {ConceptBundle} from '../../models/ConceptBundle';
import {ConceptReference} from '../../models/ConceptReference';

@Component({
  selector: 'app-concept-editor',
  templateUrl: './concept-editor.component.html',
  styleUrls: [
    './concept-editor.component.css',
  ]
})
export class ConceptEditorComponent implements AfterViewInit {
  model: Concept;
  attributes: Attribute[];
  related: RelatedConcept[];

  data: any;
  selectedNode: any;

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
    this.conceptService.getConceptBundle(id)
      .subscribe(
        (result) => this.setConcept(result),
        (error) => this.logger.error(error)
      );
  }

  setConcept(conceptBundle: ConceptBundle) {
    this.model = conceptBundle.concept;
    this.attributes = conceptBundle.attributes;
    this.related = conceptBundle.related;

    this.data = null;
    this.graph.clear();
    this.graph.assignColours([1,2,3]);
    this.graph.addNodeData(conceptBundle.concept.id, conceptBundle.concept.context, 1, conceptBundle.concept);
    this.updateDiagram(conceptBundle.concept.id, conceptBundle.attributes, conceptBundle.related);
  }

  loadDetails(conceptId: number) {
    this.conceptService.getConceptBundle(conceptId)
      .subscribe(
        (result) => this.updateDiagram(result.concept.id, result.attributes, result.related),
        (error) => this.logger.error(error)
      );
  }

  updateDiagram(conceptId: number, attributes: Attribute[], related: RelatedConcept[]) {
    for (let attribute of attributes) {
      this.graph.addNodeData(attribute.attributeId, attribute.attribute.context, 3, attribute);
      this.graph.addEdgeData(conceptId, attribute.attributeId, 'Has attribute', attribute);
    }

    for (let item of related) {
      if (item.sourceId == conceptId) {
        this.graph.addNodeData(item.targetId, item.target.context, 2, item);
        this.graph.addEdgeData(conceptId, item.targetId, item.relationship.text, item);
      } else {
        this.graph.addNodeData(item.sourceId, item.source.context, 2, item);
        this.graph.addEdgeData(item.sourceId, conceptId, item.relationship.text, item);
      }
    }

    this.graph.start();
  }

  decLimit(item: any) {
    if (item.limit > 0)
      item.limit--;
  }

  incLimit(item: any) {
    item.limit++;
  }

  getConceptStatusName(status: ConceptStatus): string {
    return ConceptStatusHelper.getName(status);
  }

  setStatus(status: ConceptStatus) {
    this.model.status = status;
  }

  addConcept() {
    ConceptPickerComponent.open(this.modal, true).result
      .then(
        (result) => this.editLinkedConcept(result)
      );
  }

  editLinkedConcept(target: Concept) {
    EditRelatedComponent.open(this.modal, this.model, target)
      .result.then(
      (result) => this.saveLinkedConcept(result, target),
      (error) => this.logger.error(error)
    )
  }

  saveLinkedConcept(linkage: ConceptReference, target: Concept) {
    if (linkage.id == 0) { // Its an attribute
      let attribute: Attribute = {
        conceptId: this.model.id,
        attributeId: target.id,
        attribute: target,
        mandatory: false,
        limit: 0,
        order: this.attributes.length + 1
      };
      this.attributes.push(attribute);
      this.updateDiagram(this.model.id, [attribute], []);
    } else {
      let related: RelatedConcept = {
        id: null,
        sourceId: this.model.id,
        source: this.model,
        targetId: target.id,
        target: target,
        relationship: linkage,
        mandatory: false,
        limit: 0,
        order: this.related.length + 1
      };
      this.related.push(related);
      this.updateDiagram(this.model.id, [], [related]);
    }
  }

  nodeClick(node) {
    this.selectedNode = node.data;
  }

  nodeDblClick(node) {
    if (!node.data.loaded) {
      node.data.loaded = true;
      this.loadDetails(node.id);
    }
  }

  save() {
    let conceptBundle: ConceptBundle = {
      concept: this.model,
      attributes: this.attributes,
      related: this.related
    };

    this.conceptService.saveBundle(conceptBundle)
      .subscribe(
        () => this.close(false),
        (error) => this.logger.error('Error during save', error, 'Save')
      );
  }

  close(withConfirm: boolean) {
    this.location.back();
  }
}
