import { Component, OnInit } from '@angular/core';
import {RecordModelService} from '../record-model.service';
import {FlatTreeControl} from '@angular/cdk/tree';
import {TreeNode} from '../../models/TreeNode';
import {TreeSource} from './TreeSource';
import {Concept} from '../../models/Concept';
import {Related} from '../../models/Related';

@Component({
  selector: 'app-record-model-library',
  templateUrl: './record-model-library.component.html',
  styleUrls: ['./record-model-library.component.css']
})
export class RecordModelLibraryComponent implements OnInit {
  treeControl: FlatTreeControl<TreeNode>;
  dataSource: TreeSource;
  concept: Concept;
  definition: Related[];
  selectedNode: TreeNode;
  searchTerm: string;
  searchResults: any[];
  searchSize = 64;

  getLevel = (node: TreeNode) => node.level;
  isExpandable = (node: TreeNode) => node.expandable;
  hasChild = (_: number, nodeData: TreeNode) => nodeData.expandable;

  constructor(private service: RecordModelService) {
    this.treeControl = new FlatTreeControl<TreeNode>(this.getLevel, this.isExpandable);
    this.dataSource = new TreeSource(this.treeControl, service, ['SN_116680003']);

    this.dataSource.data = [new TreeNode('SN_363787002', 'Test', 0, true)];
  }

  ngOnInit() {
  }

  clear() {
    this.searchTerm = '';
    this.searchSize = 64;
  }

  search() {
    this.service.search(this.searchTerm).subscribe(
      (result) => this.showResults(result),
      (error) => console.error(error)
    );
    this.searchSize = 256;
  }

  showResults(searchResults: any[]) {
    this.searchResults = searchResults;
  }

  selectNode(node: TreeNode) {
    this.selectedNode = node;
    this.service.getConcept(node.id).subscribe(
      (result) => this.concept = result,
      (error) => console.error(error)
    );

    this.service.getTargets(node.id, []).subscribe(
      (result) => this.definition = result,
      (error) => console.error(error)
    );
  }

}
