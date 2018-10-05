import {AfterViewInit, Component, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {GraphNode} from 'eds-angular4/dist/node-graph/GraphNode';
import {GraphEdge} from 'eds-angular4/dist/node-graph/GraphEdge';
import {NodeGraphComponent} from 'eds-angular4/dist/node-graph/node-graph.component';

@Component({
  selector: 'app-node-graph-dialog',
  templateUrl: './node-graph-dialog.component.html',
  styleUrls: ['./node-graph-dialog.component.css']
})
export class NodeGraphDialogComponent implements AfterViewInit {
  @ViewChild('nodeGraphDlg') graph: NodeGraphComponent;
  @ViewChild('graphContainer') graphContainer: any;

  title: string;
  nodeData: GraphNode[];
  edgeData: GraphEdge[];

  public static open(modalService: NgbModal, title: string, nodeData: GraphNode[], edgeData: GraphEdge[]) {
    const modalRef = modalService.open(NodeGraphDialogComponent, { backdrop: 'static', size: 'lg'});
    modalRef.componentInstance.title = title;
    modalRef.componentInstance.nodeData = nodeData;
    modalRef.componentInstance.edgeData = edgeData;
    return modalRef;
  }

  constructor(public activeModal: NgbActiveModal) { }

  ngAfterViewInit() {
    this.graph.assignColours([1, 2, 3, 0]);

    for (const n of this.nodeData) {
      this.graph.addNodeData(n.id, n.label, n.group, n.data);
    }

    for (const e of this.edgeData) {
      this.graph.addEdgeData(e.source.id, e.target.id, e.label, e.data);
    }

    this.graph.start();

    this.graphContainer.nativeElement.style.height = (window.innerHeight * 0.7) + 'px';
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
