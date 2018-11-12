import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {View} from '../../models/View';
import {ViewService} from '../view.service';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Location} from '@angular/common';
import {ViewFolder} from '../../models/ViewFolder';
import {ConceptSummary} from '../../models/ConceptSummary';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {Concept} from '../../models/Concept';
import {ITreeOptions, TreeComponent} from 'angular-tree-component';

@Component({
  selector: 'app-view-editor',
  templateUrl: './view-editor.component.html',
  styleUrls: ['./view-editor.component.css']
})
export class ViewEditorComponent implements AfterViewInit {
  view: View = {} as View;
  folders: ViewFolder[];
  concepts: ConceptSummary[];
  options : ITreeOptions;
  @ViewChild('tree') tree: TreeComponent;

  constructor(private route: ActivatedRoute,
              private location: Location,
              private modal: NgbModal,
              private log: LoggerService,
              private viewService: ViewService) {
    this.options = {
      displayField : 'name',
      childrenField: 'children',
      hasChildrenField : 'hasChildren',
      idField : 'id',
      isExpandedField : 'isExpanded',
      getChildren : (node) => { this.loadChildViews(node.data)}
    }
  }

  ngAfterViewInit() {
    this.route.params.subscribe(
      (params) => this.init(params['id'], params['name'])
    );
  }

  init(id: any, name: string) {
    if (id === 'add')
      setTimeout(() => this.newView(name));
    else
      this.loadView(id);
  }

  loadView(id: number) {
    this.viewService.get(id)
      .subscribe(
        (result) => {
          this.view = result;
          this.folders = [
            {
              id: result.id,
              name: result.name,
              description: result.description,
              hasChildren: true,
              children: null,
              isExpanded: false,
              loading: false
            }
          ];
          this.tree.treeModel.update();
          // this.loadChildViews(this.viewFolder[0]);
          this.loadViewConcepts(this.view);
        },
        (error) => this.log.error(error)
      );
  }

  newView(name: string) {
    this.view = {name: name} as View;
  }

  loadChildViews(folder: ViewFolder) {
    this.viewService.getViews(folder.id)
      .subscribe(
        (result) => this.addChildViews(folder, result.map((v) => ({
          id: v.id,
          name: v.name,
          description: v.description,
          hasChildren: true,
          children: null,
          isExpanded: false,
          loading: false
        } as ViewFolder))),
        (error) => this.log.error(error)
      );
  }

  addChildViews(folder: ViewFolder, children: ViewFolder[]) {
    folder.children = children;
    if (children == null || children.length == 0)
      folder.hasChildren = false;
    this.tree.treeModel.update();
  }

  loadViewConcepts(view: View) {
    this.viewService.getConcepts(view.id)
      .subscribe(
        (result) => this.concepts = result,
        (error) => this.log.error(error)
      );
  }

  addConcept() {
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (result) => this.addConceptSummary(result)
    );
  }

  addConceptSummary(concept: Concept) {
    let i = this.concepts.find((c) => c.id === concept.id);
    if (i == null) {
      this.concepts.push(
        {
          id: concept.id,
          name: concept.fullName,
          context: concept.context,
          status: concept.status,
          synonym: false
        }
      );
    }
  }

  save(close: boolean) {
    this.viewService.save(this.view)
      .subscribe(
        (result) => {
          this.view = result
          this.log.success('View saved', this.view, 'Saved');
          if (close)
            this.close(false)
        },
        (error) => this.log.error('Error during save', error, 'Save')
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
