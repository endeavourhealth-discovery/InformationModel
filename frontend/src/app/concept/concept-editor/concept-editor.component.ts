import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {Concept} from '../../models/Concept';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../concept.service';
import {Location} from '@angular/common';
import {NodeGraphComponent} from 'eds-angular4/dist/node-graph/node-graph.component';
import {NodeGraphDialogComponent} from '../node-graph-dialog/node-graph-dialog.component';
import {ModuleStateService} from 'eds-angular4/dist/common';
import {RelatedConcept} from '../../models/RelatedConcept';
import {Attribute} from '../../models/Attribute';
import {Observable} from 'rxjs/Observable';
import {ConceptEdits} from '../../models/ConceptEdits';
import {AttributeEditorComponent} from '../attribute-editor/attribute-editor.component';
import {RelatedEditorComponent} from '../related-editor/related-editor.component';
import {SynonymEditorComponent} from '../synonym-editor/synonym-editor.component';
import {Synonym} from '../../models/Synonym';
import {GraphNode} from 'eds-angular4/dist/node-graph/GraphNode';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';

@Component({
  selector: 'app-concept-editor',
  templateUrl: './concept-editor.component.html',
  styleUrls: [
    './concept-editor.component.css',
  ]
})
export class ConceptEditorComponent implements AfterViewInit {
  concept: Concept;
  related: RelatedConcept[];
  attributes: Attribute[];
  edits: ConceptEdits = new ConceptEdits();
  synonyms: Synonym[];

  data: any;
  selectedNode: any;
  testJson: string;

  @ViewChild('nodeGraph') graph: NodeGraphComponent;

  // Local enum instance
  ConceptStatus = ConceptStatus;
  getConceptStatusName = ConceptStatusHelper.getName;

  constructor(private router: Router,
              private route: ActivatedRoute,
              private location: Location,
              private logger: LoggerService,
              private modal: NgbModal,
              private conceptService: ConceptService,
              private stateService: ModuleStateService) { }

  ngAfterViewInit() {
    this.testJson = this.stateService.getState('ConceptEditor');
    this.route.params.subscribe(
      (params) => this.loadConcept(params['id'], params['context'])
      );
  }

  loadConcept(id: any, context: string) {
    if (id === 'add') {
      setTimeout(() => this.newConcept(context));
    } else {
      Observable.forkJoin(
        this.conceptService.getConcept(id),
        this.conceptService.getAttributes(id, false),
        this.conceptService.getRelated(id, false),
        this.conceptService.getSynonyms(id)
      )
        .subscribe(
          (result) => this.setData(result[0], result[1], result[2], result[3]),
          (error) => this.logger.error(error)
        );
    }
  }

  newConcept(context: string) {
    const concept = {
      superclass: {id: 1, name: 'Type'},
      context: context,
      status: ConceptStatus.DRAFT,
      version: 0.1,
      useCount: 0
    } as Concept;

    // Set full name to last part of context name as a default
    const dot = context.lastIndexOf('.');
    if (dot > 0) {
      concept.fullName = context.substring(dot + 1);
    } else {
      concept.fullName = context;
    }
    this.concept = concept;
    this.attributes = [];
    this.related = [];
    this.refreshDiagram();
  }

  setData(concept: Concept, attributes: Attribute[], related: RelatedConcept[], synonyms: Synonym[]) {
    this.concept = concept;
    this.attributes = attributes;
    this.related = related;
    this.synonyms = synonyms;
    this.refreshDiagram();
  }

  refreshDiagram() {
    if (this.concept && this.related && this.attributes) {
      this.data = null;
      this.graph.clear();
      this.graph.assignColours([1, 2, 3, 0]);
      this.graph.addNodeData(this.concept.id, this.concept.fullName, 1, this.concept, this.getAttributeTable(this.attributes));

      // this.graph.addNodeData(this.concept.superclass.id, this.concept.superclass.name, 0, this.concept.superclass);
      // this.graph.addEdgeData(this.concept.id, this.concept.superclass.id, 'inherits from', this.concept.superclass);

      this.updateDiagram(this.concept.id, this.related, this.attributes);
    }
  }

  getAttributeTable(attributes: Attribute[]) : string {
    let html : string = '';

    for(let att of attributes) {
      html += att.attribute.name + '<br>';
    }

    return html;
  }

  expandNode(node: GraphNode) {
    Observable.forkJoin([this.conceptService.getRelated(node.id, false), this.conceptService.getAttributes(node.id, false)])
      .subscribe(
        (result) => {
          node.tooltip = this.getAttributeTable(result[1]);
          this.updateDiagram(node.id, result[0], result[1]);
        },
        (error) => this.logger.error(error)
      );
  }

  updateDiagram(conceptId: number, related: RelatedConcept[], attributes: Attribute[]) {
    for (const item of related) {
      if (item.source.id === conceptId) {
        this.graph.addNodeData(item.target.id, item.target.name, 2, item);
        this.graph.addEdgeData(conceptId, item.target.id, this.getRelationshipLabel(item), item);
      } else {
        this.graph.addNodeData(item.source.id, item.source.name, 2, item);
        this.graph.addEdgeData(item.source.id, conceptId, this.getRelationshipLabel(item), item);
      }
    }

    // for (const item of attributes) {
    //   this.graph.addNodeData(item.attribute.id, item.attribute.name, 3, item);
    //   this.graph.addEdgeData(conceptId, item.attribute.id, 'has attribute', item);
    // }

    // Ensure graph isnt too big!
    if (this.graph.nodeData.length < 50) {
      this.graph.start();
    } else {
      this.graph.clear();
    }
  }

  getRelationshipLabel(related: RelatedConcept) : string {
    var result = related.relationship.name + ' (';
    result += this.getCardinality(related) + ')';
    return result;
  }

  getCardinality(related: RelatedConcept) : string {
    var result = related.mandatory ? '1..' : '0..';
    result += related.limit === 0 ? '*' : related.limit.toString();

    return result;
  }

  promptSuperclass() {
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (result) => this.setSuperclass(result)
    );
  }

  setSuperclass(concept: Concept) {
    this.concept.superclass = {id: concept.id, name: concept.fullName};
    this.refreshDiagram();
  }

  addAttribute() {
    ConceptSelectorComponent.open(this.modal, true)
      .result.then(
      (result) => {
        const att: Attribute = {
          concept: {id: this.concept.id, name: this.concept.fullName},
          attribute: {id: result.id, name: result.fullName},
          type: result.superclass,
          minimum: 0,
          maximum: 1,
        } as Attribute;

        this.editAttribute(att);
      }
    );
  }

  editAttribute(att: Attribute) {
    AttributeEditorComponent.open(this.modal, this.concept.id, att)
      .result.then(
      (result) => {
        if (result) {
          if (!this.attributes.includes(att)) {
            this.attributes.push(att);
            this.updateDiagram(this.concept.id, [], [att]);
          }
          if (!this.edits.editedAttributes.includes(result)) {
            this.edits.editedAttributes.push(result);
          }
        }
      }
    );
  }

  deleteAttribute(att: Attribute) {
    if (att.concept.id === this.concept.id) {
      let idx = this.attributes.indexOf(att);
      this.attributes.splice(idx, 1);

      idx = this.edits.editedAttributes.indexOf(att);
      if (idx > -1) {
        this.edits.editedAttributes.splice(idx, 1);
      }

      if (att.id !== 0) {
        this.edits.deletedAttributes.push(att);
      }
    }
    this.refreshDiagram()
  }


  addRelated() {
    const rel: RelatedConcept = {
      source: {id: this.concept.id, name: this.concept.fullName},
      mandatory: false,
      limit: 1
    } as RelatedConcept;

    this.editRelated(rel);
  }

  editRelated(rel: RelatedConcept) {
    RelatedEditorComponent.open(this.modal, this.concept.id, rel)
      .result.then(
      (result) => {
        if (result) {
          if (!this.related.includes(rel)) {
            this.related.push(rel);
            this.updateDiagram(this.concept.id, [rel], []);
          }
          if (!this.edits.editedRelated.includes(result)) {
            this.edits.editedRelated.push(result);
          }
        }
      },
      (error) => {}
    );
  }

  deleteRelated(rel: RelatedConcept) {
    let idx = this.related.indexOf(rel);
    this.related.splice(idx, 1);

    idx = this.edits.editedRelated.indexOf(rel);
    if (idx > -1) {
      this.edits.editedRelated.splice(idx, 1);
    }

    if (rel.id !== 0) {
      this.edits.deletedRelated.push(rel);
    }

    this.refreshDiagram();
  }

  nodeClick(node) {
    this.selectedNode = node.data;
  }

  nodeDblClick(node) {
    if (!node.data.loaded) {
      node.data.loaded = true;
      this.expandNode(node);
    }
  }

  zoom() {
    NodeGraphDialogComponent.open(this.modal, 'Concept graph', this.graph.nodeData, this.graph.edgeData)
      .result.then(
      () => {},
      () => {}
    );
  }

  editSynonyms() {
    SynonymEditorComponent.open(this.modal, this.synonyms)
      .result.then(
      (ok) => {},
      (cancel) => {}
    )
  }

  save(close: boolean) {
     this.conceptService.save(this.concept, this.edits)
       .subscribe(
         (result) => {
           this.concept = result.concept;
           this.edits = result.edits;
           this.logger.success('Concept saved', this.concept, 'Saved');
           if (close)
             this.close(false)
         },
         (error) => this.logger.error('Error during save', error, 'Save')
       );
  }

  close(withConfirm: boolean) {
    if (!withConfirm)
      this.location.back();
    else
      MessageBoxDialog.open(this.modal, 'Close concept editor', 'Unsaved changes will be lost.  Do you want to close the editor?', 'Close editor', 'Cancel')
        .result.then(
        (result) => this.location.back()
      )
  }
}
