import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {ViewItem} from '../../models/ViewItem';
import {ViewService} from '../view.service';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Location} from '@angular/common';
import {ConceptSummary} from '../../models/ConceptSummary';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {Concept} from '../../models/Concept';
import {ITreeOptions, TreeComponent} from 'angular-tree-component';
import {ViewItemEditorComponent} from '../view-item-editor/view-item-editor.component';
import {Attribute} from '../../models/Attribute';
import {View} from '../../models/View';

@Component({
  selector: 'app-view-editor',
  templateUrl: './view-editor.component.html',
  styleUrls: ['./view-editor.component.css']
})
export class ViewEditorComponent implements AfterViewInit {
  view: View = {} as View;
  items: ViewItem[] = [];
  concepts: ConceptSummary[];
  options : ITreeOptions;
  selectedFolder: ViewItem;
  @ViewChild('tree') tree: TreeComponent;

  constructor(private route: ActivatedRoute,
              private location: Location,
              private modal: NgbModal,
              private log: LoggerService,
              private viewService: ViewService) {
    this.options = {
      childrenField: 'children',
      hasChildrenField : 'hasChildren',
      idField : 'id',
      isExpandedField : 'isExpanded',
      getChildren : (node) => { this.loadChildViews(node.data)}
    }
  }

  ngAfterViewInit() {
    this.route.params.subscribe(
      (params) => this.loadView(params['id'])
    );
  }

  loadView(id: any) {
    this.viewService.getView(id)
      .subscribe(
        (result) => this.setView(result),
        (error) => this.log.error(error)
      );
  }

  setView(view: View) {
    this.view = view;
    this.items.push({
      conceptId: null,        // To denote root node
      conceptName: 'View items',
      hasChildren: true
      } as ViewItem
    );
    this.tree.treeModel.update();
  }

  updated() {
    // Expand root if not already done
    const firstRoot = this.tree.treeModel.getFirstRoot();
    if (!firstRoot)
      return;
    else {
      if (this.tree.treeModel.getActiveNode() == null) {
        firstRoot.expand();
        firstRoot.setIsActive(true);
      }
    }
  }

  selectNode(node : ViewItem) {
    if (node === this.selectedFolder) { return; }
    this.selectedFolder = node;
  }


  loadChildViews(viewItem: ViewItem) {
    this.viewService.getViewContents(this.view.id, viewItem.conceptId)
      .subscribe(
        (result) => {
          result.forEach((r) => r.hasChildren = true);
          this.addChildViews(viewItem, result);
          },
        (error) => this.log.error(error)
      );
  }

  save() {
    this.viewService.save(this.view)
      .subscribe(
        (result) => {
          this.view = result;
          this.log.success('Save successful', result, 'Save view')
        },
        (error) => this.log.error(error)
      );
  }

  addChildViews(folder: ViewItem, children: ViewItem[]) {
    folder.children = children;
    if (children == null || children.length == 0)
      folder.hasChildren = false;
    this.tree.treeModel.update();
  }

  addConcept() {
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (result) => this.addConceptSummary(result)
    );
  }

  addConceptSummary(concept: Concept) {
    ViewItemEditorComponent.open(this.modal, this.selectedFolder, concept)
      .result.then(
      (result) => this.addToView(result.addStyle, concept, result.attributes)
    );
  }

  addToView(addStyle: string, concept: Concept, attributes: Attribute[]) {
    this.viewService.addViewItem(this.view.id, addStyle, concept.id, attributes.map(a => a.attribute.id), this.selectedFolder.conceptId)
      .subscribe(
        (result) => {
          this.selectedFolder.isExpanded = false;
          this.selectedFolder.children = null;
          this.selectedFolder.hasChildren = true;
          this.tree.treeModel.update();
        },
        (error) => this.log.error(error)
      );
  }


  added(view: ViewItem) {
    this.log.success('Added!!! :)', view);
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
