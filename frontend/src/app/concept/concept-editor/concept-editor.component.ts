import {AfterViewInit, Component, OnInit, ViewChild} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {InputBoxDialog, LoggerService, MessageBoxDialog} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {ConceptPickerComponent} from '../concept-picker/concept-picker.component';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../concept.service';
import {Location} from '@angular/common';
import {RelatedConcept} from '../../models/RelatedConcept';
import {EditRelatedComponent} from '../edit-related/edit-related.component';
import {Attribute} from '../../models/Attribute';
import {ConceptBundle} from '../../models/ConceptBundle';
import {ConceptReference} from '../../models/ConceptReference';
import {ConceptSummary} from '../../models/ConceptSummary';
import {NodeGraphComponent} from 'eds-angular4/dist/node-graph/node-graph.component';
import {NodeGraphDialogComponent} from '../node-graph-dialog/node-graph-dialog.component';
import {ConceptRuleset} from '../../models/ConceptRuleset';

@Component({
  selector: 'app-concept-editor',
  templateUrl: './concept-editor.component.html',
  styleUrls: [
    './concept-editor.component.css',
  ]
})
export class ConceptEditorComponent implements AfterViewInit {
  conceptBundle: ConceptBundle;

  data: any;
  selectedNode: any;

  @ViewChild('nodeGraph') graph: NodeGraphComponent;

  // Local enum instance
  ConceptStatus = ConceptStatus;

  constructor(private router: Router,
              private route: ActivatedRoute,
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

  loadConcept(id: any) {
    if (id === 'add') {
      setTimeout(() => this.promptContext());
    } else {
      this.conceptService.getConceptBundle(id)
        .subscribe(
          (result) => this.setConcept(result),
          (error) => this.logger.error(error)
        );
    }
  }

  promptContext() {
    InputBoxDialog.open(this.modal, 'Add concept', 'Enter context name for the new concept', '', 'OK', 'Cancel')
      .result.then(
      (result) => this.newConcept(result)
    );
  }

  changeType() {
    ConceptPickerComponent.open(this.modal, false)
      .result.then(
      (result) => this.setType(result)
    );
  }

  setType(type: ConceptSummary) {
    this.conceptBundle.concept.type = {
      id: type.id,
      text: type.fullName
    };
  }

  newConcept(context: string) {
    let concept = new Concept();
    concept.context = context;
    this.setConcept({
      concept: concept,
      related: [],
      attributes: [],
      ruleSets: [],
      deletedRelatedIds: [],
      deletedAttributeIds: [],
      deletedRuleSetIds: []
    });
  }

  setConcept(conceptBundle: ConceptBundle) {
    this.conceptBundle = conceptBundle;
    this.refresh();
  }

  refresh() {
    this.data = null;
    this.graph.clear();
    this.graph.assignColours([1,2,3,0]);
    this.graph.addNodeData(this.conceptBundle.concept.id, this.conceptBundle.concept.fullName, 1, this.conceptBundle.concept);

    this.updateDiagram(this.conceptBundle.concept, this.conceptBundle.attributes, this.conceptBundle.related);
  }

  loadDetails(conceptId: number) {
    this.conceptService.getConceptBundle(conceptId)
      .subscribe(
        (result) => this.updateDiagram(result.concept, result.attributes, result.related),
        (error) => this.logger.error(error)
      );
  }

  updateDiagram(concept: Concept, attributes: Attribute[], related: RelatedConcept[]) {
    // Base type (if not base "Concept")
    if (concept.type.id != 1) {
      this.graph.addNodeData(concept.type.id, concept.type.text, 0, concept.type);
      this.graph.addEdgeData(concept.id, concept.type.id, 'Inherits from', concept.type);
    }

    for (let attribute of attributes) {
      this.graph.addNodeData(attribute.attributeId, attribute.attribute.context, 3, attribute);
      this.graph.addEdgeData(concept.id, attribute.attributeId, 'Has attribute', attribute);
    }

    for (let item of related) {
      if (item.sourceId == concept.id) {
        this.graph.addNodeData(item.targetId, item.target.fullName, 2, item);
        this.graph.addEdgeData(concept.id, item.targetId, item.relationship.text, item);
      } else {
        this.graph.addNodeData(item.sourceId, item.source.fullName, 2, item);
        this.graph.addEdgeData(item.sourceId, concept.id, item.relationship.text, item);
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
    this.conceptBundle.concept.status = status;
  }

  addConcept() {
    ConceptPickerComponent.open(this.modal, true).result
      .then(
        (result) => this.editLinkedConcept(result)
      );
  }

  editLinkedConcept(target: Concept) {
    EditRelatedComponent.open(this.modal, this.conceptBundle.concept, target)
      .result.then(
      (result) => this.saveLinkedConcept(result, target),
      (error) => this.logger.error(error)
    )
  }

  saveLinkedConcept(linkage: ConceptReference, target: Concept) {
    // TODO : Logic for checking and removing from DELETED lists
    if (linkage.id == 0) { // Its an attribute
      let attribute: Attribute = {
        id: null,
        conceptId: this.conceptBundle.concept.id,
        attributeId: target.id,
        attribute: new ConceptSummary(target),
        mandatory: false,
        limit: 0,
        order: this.conceptBundle.attributes.length + 1
      };
      this.conceptBundle.attributes.push(attribute);
      this.updateDiagram(this.conceptBundle.concept, [attribute], []);
    } else {
      let related: RelatedConcept = {
        id: null,
        sourceId: this.conceptBundle.concept.id,
        source: null,
        targetId: target.id,
        target: new ConceptSummary(target),
        relationship: linkage,
        mandatory: false,
        limit: 0,
        order: this.conceptBundle.related.length + 1
      };
      this.conceptBundle.related.push(related);
      this.updateDiagram(this.conceptBundle.concept, [], [related]);
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

  gotoConcept(conceptId: number) {
    this.router.navigate(['concept', conceptId]);
  }

  confirmDeleteAttribute(attribute: Attribute) {
    MessageBoxDialog.open(this.modal, 'Concept editor', 'Are you sure that you want to delete the attribute "' + attribute.attribute.context + '"?', 'Delete attribute', 'Cancel')
      .result.then(
      (ok) => this.deleteAttribute(attribute),
      (error) => this.logger.error(error)
    );
  }

  deleteAttribute(attribute: Attribute) {
    let idx = this.conceptBundle.attributes.indexOf(attribute);
    if (idx > -1) {
      this.conceptBundle.attributes.splice(idx, 1);
      if (attribute.id != 0)
        this.conceptBundle.deletedAttributeIds.push(attribute.id);
    }
  }

  confirmDeleteRelationship(relatedConcept: RelatedConcept) {
    let context = relatedConcept.target ? relatedConcept.target.context : relatedConcept.source.context;
    MessageBoxDialog.open(this.modal, 'Concept editor', 'Are you sure that you want to delete the relationship with "' + context + '"?', 'Delete relationship', 'Cancel')
      .result.then(
      (ok) => this.deleteRelationship(relatedConcept)
    );
  }

  deleteRelationship(relatedConcept: RelatedConcept) {
    let idx = this.conceptBundle.related.indexOf(relatedConcept);
    if (idx > -1) {
      this.conceptBundle.related.splice(idx, 1);
      if (relatedConcept.id > 0)
        this.conceptBundle.deletedRelatedIds.push(relatedConcept.id);
    }
  }

  getRuleText(item: ConceptRuleset) {
    let ruleText: string = '';
    for(let i in item.rules) {
      if (i !== '0')
        ruleText += ' AND ';
      ruleText += item.rules[i].property + " " + item.rules[i].comparator + " " + item.rules[i].value;
    }

    return ruleText;
  }

  zoom() {
    NodeGraphDialogComponent.open(this.modal, 'Concept graph', this.graph.nodeData, this.graph.edgeData)
      .result.then(
      () => {}
    );
  }

  save() {
    this.conceptService.saveBundle(this.conceptBundle)
      .subscribe(
        () => this.close(false),
        (error) => this.logger.error('Error during save', error, 'Save')
      );
  }

  close(withConfirm: boolean) {
    this.location.back();
  }
}
