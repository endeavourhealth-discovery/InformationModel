import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../concept.service';
import {Location} from '@angular/common';
import {NodeGraphComponent} from 'eds-angular4/dist/node-graph/node-graph.component';
import {NodeGraphDialogComponent} from '../node-graph-dialog/node-graph-dialog.component';
import {GraphNode} from 'eds-angular4/dist/node-graph/GraphNode';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {ConceptRawComponent} from '../concept-raw/concept-raw.component';
import {Concept} from '../../models/Concept';

@Component({
  selector: 'app-concept-editor',
  templateUrl: './concept-editor.component.html',
  styleUrls: [
    './concept-editor.component.css',
  ]
})
export class ConceptEditorComponent implements AfterViewInit {
  concept: Concept = null;
  documents: string[] = [];
  nature: string;
  superclass: string;
  nameCache: any = {};
  generatingRuntime: boolean = false;
  loadingRuntime: boolean = false;

  @ViewChild('nodeGraph') graph: NodeGraphComponent;

  constructor(private router: Router,
              private route: ActivatedRoute,
              private location: Location,
              private logger: LoggerService,
              private modal: NgbModal,
              private conceptService: ConceptService) { }

  ngAfterViewInit() {
    this.route.params.subscribe(
      (params) => this.loadConcept(params['id'])
    );
    this.conceptService.getDocuments()
      .subscribe(
        (result) => this.documents = result,
        (error) => this.logger.error(error)
      );
  }

  loadConcept(id: any) {
    this.concept = null;
    this.nameCache = [];
    this.conceptService.getConcept(id)
      .subscribe(
        (result) => {
          this.concept = result;
          if (this.concept['is_instance_of'] != null)
            this.nature = 'is_instance_of';
          else
            this.nature = 'is_subtype_of';

          if (this.concept[this.nature] == null)
            this.concept[this.nature] = {'id': 'Concept'};

          this.superclass = this.concept[this.nature]['id'];
        }
      );
  }

  promptAddProperty() {
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (result) => this.addProperty(result),
      () => {}
    )
  }

  addProperty(property: any) {
    if (this.concept[property] === undefined) {
      this.concept[property] = '';
    }
  }

  refreshDiagram() {
    if (this.concept) {
      this.graph.clear();
      this.graph.assignColours([1, 2, 3, 0]);
      this.graph.addNodeData(this.concept.dbid, this.concept.name, 1, this.concept);

      for(let key of Object.keys(this.concept)) {
        let prop = this.concept[key];

        if (prop.id) {
          this.graph.addNodeData(prop.id, prop.id, 0, prop);
          this.graph.addEdgeData(this.concept.dbid, prop.id, key, prop);
        } else {
          this.graph.addNodeData(prop, prop, 0, prop);
          this.graph.addEdgeData(this.concept.dbid, prop, key, prop);
        }
      }

      // this.graph.addNodeData(this.concept.superclass.id, this.concept.superclass.name, 0, this.concept.superclass);
      // this.graph.addEdgeData(this.concept.id, this.concept.superclass.id, 'inherits from', this.concept.superclass);

      // this.updateDiagram(this.concept.id, this.attributes);
      this.graph.start();
    }
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

  updateDiagram(conceptId: number) {
    // for (const item of related) {
    //   if (item.source.id === conceptId) {
    //     this.graph.addNodeData(item.target.id, item.target.name, 2, item);
    //     this.graph.addEdgeData(conceptId, item.target.id, this.getRelationshipLabel(item), item);
    //   } else {
    //     this.graph.addNodeData(item.source.id, item.source.name, 2, item);
    //     this.graph.addEdgeData(item.source.id, conceptId, this.getRelationshipLabel(item), item);
    //   }
    // }

    // for (const item of attributes) {
    //   this.graph.addNodeData(item.attribute.id, item.attribute.name, 3, item);
    //   this.graph.addEdgeData(conceptId, item.attribute.id, 'has', item);
    // }

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

  selectSupertype() {
    ConceptSelectorComponent.open(this.modal, this.superclass)
      .result.then(
      (result) => this.superclass = result.id,
      () => {}
    );
  }


  nodeClick(node) {
    // this.selectedNode = node.data;
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

  save(close: boolean) {
    // cleanup nature
    delete this.concept['is_subtype_of'];
    delete this.concept['is_instance_of'];
    this.concept[this.nature] = { 'id' : this.superclass };

     this.conceptService.updateConcept(this.concept, 2)
       .subscribe(
         () => {
           this.logger.success('Concept saved', this.concept, 'Saved');
           if (close)
             this.close(false)
         },
         (error) => this.logger.error('Error during save', error, 'Save')
       );
  }

  promptDeleteConcept() {
    MessageBoxDialog.open(this.modal, 'Delete concept', 'Delete the <b><i>' + this.concept.id + '</i></b> concept?', 'Delete', 'Cancel')
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

  navigateTo(id: any) {
    this.router.navigate(['concept', id])
  }

  getProperties() {
    const ignore: string[] = ['id', 'document', 'name', 'description', 'is_subtype_of', 'is_instance_of'];
    return Object.keys(this.concept).filter(k => ignore.indexOf(k) == -1);
  }

  getValues(v): string[] {
    if (v instanceof Array) {
      let elem: string[] = [];

      for (let i of v) {
        elem = elem.concat(this.getValues(i));
      }

      return elem;
    }

    if (v instanceof Object) {
      if (v['id'] != null)
        return [v['id']];

      if (v['has_value_type'] != null)
        return this.getValues(v['has_value_type']);

      return [JSON.stringify(v)];
    }

    return [v];
  }

  getName(id: string)  {
    if (id == null)
      return null;

    let result = this.nameCache[id];

    if (result == null) {
      this.nameCache[id] = id;
      result = this.nameCache[id];

      this.conceptService.getName(id)
        .subscribe(
          (name) => { if (name != null && name != '') this.nameCache[id] = name },
          (error) => this.logger.error(error)
        )
    }

    return result;
  }

  editRaw() {
    ConceptRawComponent.open(this.modal, this.concept)
      .result.then(
      (result) => this.concept = result,
      () => {}
    )
  }

  generateRuntime() {
    if (this.generatingRuntime)
      return;

    this.generatingRuntime = true;
    this.conceptService.generateRuntime()
      .subscribe(
        (success) => {
          this.generatingRuntime = false;
          this.logger.success("Runtime file generated")
        },
        (error) => {
          this.generatingRuntime = false;
          this.logger.error(error);
        }
      );
  }

  loadRuntime() {
    if (this.loadingRuntime)
      return;

    this.loadingRuntime = true;
    this.conceptService.loadRuntime()
      .subscribe(
        (success) => {
          this.loadingRuntime = false;
          this.logger.success("Runtime file loaded")
        },
        (error) => {
          this.loadingRuntime = false;
          this.logger.error(error);
        }
      );
  }
}
