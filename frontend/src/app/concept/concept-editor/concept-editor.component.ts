import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../concept.service';
import {Location} from '@angular/common';
import {NodeGraphComponent} from 'eds-angular4/dist/node-graph/node-graph.component';
import {NodeGraphDialogComponent} from '../node-graph-dialog/node-graph-dialog.component';
import {ModuleStateService} from 'eds-angular4/dist/common';
import {Attribute} from '../../models/Attribute';
import {Observable} from 'rxjs/Observable';
import {AttributeEditorComponent} from '../attribute-editor/attribute-editor.component';
import {SynonymEditorComponent} from '../synonym-editor/synonym-editor.component';
import {Synonym} from '../../models/Synonym';
import {GraphNode} from 'eds-angular4/dist/node-graph/GraphNode';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {ValueExpressionHelper} from '../../models/ValueExpression';
import {InheritanceHelper} from '../../models/Inheritance';
import {CardinalityHelper} from '../../models/CardinalityHelper';
import {ConceptCreateComponent} from '../concept-create/concept-create.component';
import {Concept} from 'im-common/dist/models/Concept';
import {ConceptStatus, ConceptStatusHelper} from 'im-common/dist/models/ConceptStatus';

@Component({
  selector: 'app-concept-editor',
  templateUrl: './concept-editor.component.html',
  styleUrls: [
    './concept-editor.component.css',
  ]
})
export class ConceptEditorComponent implements AfterViewInit {
  concept: Concept;
  attributes: Attribute[];
  synonyms: Synonym[];

  data: any;
  selectedNode: any;
  testJson: string;

  @ViewChild('nodeGraph') graph: NodeGraphComponent;

  // Local enum instance
  ConceptStatus = ConceptStatus;
  getConceptStatusName = ConceptStatusHelper.getName;
  getValueExpressionPrefix = ValueExpressionHelper.getPrefix;
  getInheritanceIcon = InheritanceHelper.getIcon;
  getCardinality = CardinalityHelper.asNumeric;

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
    console.log(id);
    console.log(context);
    if (id === 'add') {
      setTimeout(() => this.newConcept(context));
    } else {
      Observable.forkJoin(
        this.conceptService.getConcept(id),
        this.conceptService.getAttributes(id, false),
        this.conceptService.getSynonyms(id)
      )
        .subscribe(
          (result) => {
            this.concept = result[0];
            this.attributes = result[1];
            this.synonyms = result[2];
            this.refreshDiagram();
          }
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
    this.refreshDiagram();
  }

  refreshDiagram() {
    if (this.concept && this.attributes) {
      this.data = null;
      this.graph.clear();
      this.graph.assignColours([1, 2, 3, 0]);
      this.graph.addNodeData(this.concept.id, this.concept.fullName, 1, this.concept, this.getAttributeTable(this.attributes));

      // this.graph.addNodeData(this.concept.superclass.id, this.concept.superclass.name, 0, this.concept.superclass);
      // this.graph.addEdgeData(this.concept.id, this.concept.superclass.id, 'inherits from', this.concept.superclass);

      this.updateDiagram(this.concept.id, this.attributes);
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
    // Observable.forkJoin([this.conceptService.getRelated(node.id, false), this.conceptService.getAttributes(node.id, false)])
    //   .subscribe(
    //     (result) => {
    //       node.tooltip = this.getAttributeTable(result[1]);
    //       this.updateDiagram(node.id, result[0], result[1]);
    //     },
    //     (error) => this.logger.error(error)
    //   );
  }

  updateDiagram(conceptId: number, attributes: Attribute[]) {
    // for (const item of related) {
    //   if (item.source.id === conceptId) {
    //     this.graph.addNodeData(item.target.id, item.target.name, 2, item);
    //     this.graph.addEdgeData(conceptId, item.target.id, this.getRelationshipLabel(item), item);
    //   } else {
    //     this.graph.addNodeData(item.source.id, item.source.name, 2, item);
    //     this.graph.addEdgeData(item.source.id, conceptId, this.getRelationshipLabel(item), item);
    //   }
    // }

    for (const item of attributes) {
      this.graph.addNodeData(item.attribute.id, item.attribute.name, 3, item);
      this.graph.addEdgeData(conceptId, item.attribute.id, 'has', item);
    }

    // Ensure graph isnt too big!
    if (this.graph.nodeData.length < 50) {
      this.graph.start();
    } else {
      this.graph.clear();
    }
  }

  // getRelationshipLabel(related: RelatedConcept) : string {
  //   var result = related.relationship.name;
  //   result += this.getCardinality(related.mandatory, related.limit);
  //   return result;
  // }

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
    ConceptSelectorComponent.open(this.modal, true) //, 6, ValueExpression.OF_CLASS)
      .result.then(
      (result) => {
        if (result.id == null)
          this.createAttributeConcept();
        else
          this.createAttribute(result);
      }
    );
  }

  createAttributeConcept() {
    let commonSubtypes = [
      {id: 6, name: 'Attribute'},
      {id: 7, name: 'Codeable attribute'},
      {id: 8, name: 'Number attribute'},
      {id: 9, name: 'Whole Number attribute'},
      {id: 10, name: 'Decimal attribute'},
      {id: 11, name: 'Date time attribute'},
      {id: 12, name: 'Text attribute'},
      {id: 13, name: 'Boolean attribute'}
    ];
    ConceptCreateComponent.open(this.modal, commonSubtypes)
      .result.then(
      (result) => this.createAttribute(result),
      (error) => this.logger.error(error)
    );
  }

  createAttribute(attConcept: Concept) {
    const att: Attribute = {
      concept: {id: this.concept.id, name: this.concept.fullName},
      attribute: {id: attConcept.id, name: attConcept.fullName},
      mandatory: false,
      limit: 1,
      order: 0,
      inheritance: 1,
      status: ConceptStatus.DRAFT,
      valueExpression: 0
    } as Attribute;

    this.editAttribute(att);
  }

  editAttribute(att: Attribute) {
    AttributeEditorComponent.open(this.modal, this.concept.id, att)
      .result.then(
      (result) => {
        if (result) {
          if (!this.attributes.includes(att)) {
            this.attributes.unshift(result);
          } else {
            Object.assign(att, result);
          }
        }
      }
    );
  }

  promptDeleteAttribute(att: Attribute) {
    MessageBoxDialog.open(this.modal, 'Delete attribute', 'Delete the attribute from this concept?', 'Delete', 'Cancel')
      .result.then(
      (result) => this.deleteAttribute(att)
    );
  }

  deleteAttribute(att: Attribute) {
    this.conceptService.deleteAttribute(att.id)
      .subscribe(
        (result) => {
          if (att.concept.id === this.concept.id) {
            let idx = this.attributes.indexOf(att);
            this.attributes.splice(idx, 1);
          } else {
            this.loadAttributes();
          }
          this.refreshDiagram()
        },
        (error) => this.logger.error(error)
      );
  }

  loadAttributes() {
    this.conceptService.getAttributes(this.concept.id, false)
      .subscribe(
        (result) => this.attributes = result,
        (error) => this.logger.error(error)
      );

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

  saveConcept(close: boolean) {
     this.conceptService.save(this.concept)
       .subscribe(
         (result) => {
           this.concept = result;
           this.logger.success('Concept saved', this.concept, 'Saved');
           if (close)
             this.close(false)
         },
         (error) => this.logger.error('Error during save', error, 'Save')
       );
  }

  promptDeleteConcept() {
    MessageBoxDialog.open(this.modal, 'Delete concept', 'Delete the <b><i>' + this.concept.context + '</i></b> concept?', 'Delete', 'Cancel')
      .result.then(
      (result) => this.deleteConcept()
    );
  }

  deleteConcept() {
    this.conceptService.deleteConcept(this.concept.id)
      .subscribe(
        (result) => this.close(false),
        (error) => this.logger.error(error)
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
