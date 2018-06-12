import {GraphNode} from './GraphNode';

export class GraphEdge {
  source: GraphNode;
  target: GraphNode;
  label: string;
  x: number = 0;
  y: number = 0;
  d: number = 0;
}
