import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {LoggerService} from 'eds-angular4';
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
import {EditRelatedComponent} from '../edit-related/edit-related.component';
import {Attribute} from '../../models/Attribute';
import {ConceptBundle} from '../../models/ConceptBundle';

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
    this.data = null;
    this.graph.clear();
    this.graph.assignColours([1,2,3]);
    this.graph.addNodeData(conceptBundle.concept.id, conceptBundle.concept.context, 1, conceptBundle.concept);
    this.setLinkedConcepts(conceptBundle.concept.id, conceptBundle.attributes, conceptBundle.related);
  }

  loadDetails(conceptId: number) {
    this.conceptService.getConceptBundle(conceptId)
      .subscribe(
        (result) => this.setLinkedConcepts(result.concept.id, result.attributes, result.related),
        (error) => this.logger.error(error)
      );
  }

  setLinkedConcepts(conceptId: number, /*,*/ attributes: Attribute[], related: RelatedConcept[]) {
    if (conceptId === this.model.id) {
      this.attributes = attributes;
      this.related = related;
    }

    for (let attribute of attributes) {
      this.graph.addNodeData(attribute.attributeId, attribute.attribute.context, 3, attribute);
      this.graph.addEdgeData(conceptId, attribute.attributeId, 'Has attribute', attribute);
    }

    for (let item of related) {
      if (item.sourceId == conceptId) {
        this.graph.addNodeData(item.targetId, item.target.context, 2, item);
        this.graph.addEdgeData(conceptId, item.targetId, item.relationship, item);
      } else {
        // for (let source of sources) {
        this.graph.addNodeData(item.sourceId, item.source.context, 2, item);
        this.graph.addEdgeData(item.sourceId, conceptId, item.relationship, item);
      }
    }

    this.graph.start();
  }

  getConceptStatusName(status: ConceptStatus): string {
    return ConceptStatusHelper.getName(status);
  }

  setStatus(status: ConceptStatus) {
    this.model.status = status;
  }

  addConcept() {
    ConceptPickerComponent.open(this.modal).result
      .then(
        (result) => this.editLinkedConcept(result),
        (error) => this.logger.error(error)
      );
  }

  editLinkedConcept(target: Concept) {
    EditRelatedComponent.open(this.modal, this.model, target)
      .result.then(
      (result) => this.saveLinkedConcept(result, target),
      (error) => this.logger.error(error)
    )
  }

  saveLinkedConcept(relationship: ConceptSummary, target) {
/*    if (relationship) {

      console.log(target);
      console.log(relationship);

      if (!target.id) {
        this.conceptService.save(target)
          .subscribe(
            (result) => {target.id = result; this.saveLink(target, relationship)},
            (error) => this.logger.error(error)
          );
      } else {
        this.saveLink(target, relationship)
      }
    }
  }

  saveLink(target: Concept, relationship: any) {

    if (relationship.id === 0) {
      this.conceptService.saveAttribute(this.model.id, target.id)
        .subscribe(
          (result) => this.addLinkToGraph(target, relationship),
          (error) => this.logger.error(error)
        );
    } else {
      this.conceptService.saveRelationship(this.model.id, target.id, relationship.id)
        .subscribe(
          (result) => this.addLinkToGraph(target, relationship),
          (error) => this.logger.error(error)
        );
    }
  }

  addLinkToGraph(target: Concept, relationship: any) {
    if (relationship.id === 0) {
      this.graph.addNodeData(target.id, target.context, 3, target);
    } else {
      this.graph.addNodeData(target.id, target.context, 2, target);
    }

    this.graph.addEdgeData(this.model.id, target.id, relationship.name, relationship);
    this.graph.start(); */
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
