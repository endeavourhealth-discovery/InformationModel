import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {ViewItem} from '../../models/ViewItem';
import {ViewService} from '../view.service';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Location} from '@angular/common';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {ITreeOptions, TreeComponent} from 'angular-tree-component';
import {ViewItemEditorComponent} from '../view-item-editor/view-item-editor.component';
import {Attribute} from '../../models/Attribute';
import {View} from '../../models/View';
import {ConceptSummary} from 'im-common/dist/models/ConceptSummary';
import {Concept} from 'im-common/dist/models/Concept';

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
          if (viewItem.conceptId === 2)
            this.log.warning('Codeable concepts restricted to 200 items for performance!', null, 'Partial load');
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

  addItem() {
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (concept) => {
        ViewItemEditorComponent.open(this.modal, this.selectedFolder, concept)
          .result.then(
          (result) => this.addToView(result.addStyle, concept, result.attributes)
        );
      }
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
          this.log.success('Successfully added the item to this view.', null, 'Add to view');
        },
        (error) => this.log.error(error)
      );
  }

  removeItem() {
    MessageBoxDialog.open(this.modal, 'Remove item from view', 'Do you want to remove <b><i>'+this.selectedFolder.conceptName+'</i></b> from the view?', 'Remove', 'Cancel')
      .result.then(
      (confirm) => {
        this.viewService.removeViewItem(this.selectedFolder.id)
          .subscribe(
            (result) => this.removeFromView(),
            (error) => this.log.error(error)
          );
      }
    );
  }

  removeFromView() {
    // Go to parent node
    let parent = this.tree.treeModel.getActiveNode().parent;
    this.selectedFolder = parent.data;
    this.selectedFolder.isExpanded = false;
    this.selectedFolder.children = null;
    this.selectedFolder.hasChildren = true;
    this.tree.treeModel.update();
    this.log.success('Successfully removed '+this.selectedFolder.conceptName+' from this view', this.selectedFolder, 'Remove from view');
  }

  close(withConfirm: boolean) {
    if (!withConfirm)
      this.location.back();
    else
      MessageBoxDialog.open(this.modal, 'Close concept editor', 'Any unsaved changes will be lost.  Do you want to close the editor?', 'Close editor', 'Cancel')
        .result.then(
        (result) => this.location.back()
      )
  }
}
