import {TreeNode} from '../../models/TreeNode';
import {CollectionViewer, DataSource, SelectionChange} from '@angular/cdk/collections';
import {BehaviorSubject, merge, Observable} from 'rxjs';
import {FlatTreeControl} from '@angular/cdk/tree';
import {RecordModelService} from '../record-model.service';
import {map} from 'rxjs/operators';

export class TreeSource implements DataSource<TreeNode> {

  dataChange = new BehaviorSubject<TreeNode[]>([]);

  get data(): TreeNode[] { return this.dataChange.value; }
  set data(value: TreeNode[]) {
    this.treeControl.dataNodes = value;
    this.dataChange.next(value);
  }

  constructor(private treeControl: FlatTreeControl<TreeNode>,
              private database: RecordModelService,
              private relationships: string[]) {}

  connect(collectionViewer: CollectionViewer): Observable<TreeNode[]> {
    this.treeControl.expansionModel.changed.subscribe(change => {
      if ((change as SelectionChange<TreeNode>).added ||
        (change as SelectionChange<TreeNode>).removed) {
        this.handleTreeControl(change as SelectionChange<TreeNode>);
      }
    });

    return merge(collectionViewer.viewChange, this.dataChange).pipe(map(() => this.data));
  }

  disconnect(collectionViewer: CollectionViewer): void {}

  /** Handle expand/collapse behaviors */
  handleTreeControl(change: SelectionChange<TreeNode>) {
    if (change.added) {
      change.added.forEach(node => this.toggleNode(node, true));
    }
    if (change.removed) {
      change.removed.slice().reverse().forEach(node => this.toggleNode(node, false));
    }
  }

  /**
   * Toggle the node, remove from display list
   */
  toggleNode(node: TreeNode, expand: boolean) {
    const index = this.data.indexOf(node);
    node.isLoading = true;

    if (expand) {
      this.database.getSources(node.id, this.relationships).subscribe(
      (children) => {
        const nodes = children.map(related =>
          new TreeNode(related.concept.id, related.concept.name, node.level + 1, true));
        this.data.splice(index + 1, 0, ...nodes);

        // notify the change
        this.dataChange.next(this.data);
        node.isLoading = false;
      },
      (error) => console.error(error)
    );
    } else {
      let count = 0;
      for (let i = index + 1; i < this.data.length
      && this.data[i].level > node.level; i++, count++) {}
      this.data.splice(index + 1, count);
      this.dataChange.next(this.data);
      node.isLoading = false;
    }
  }
}
