import {Component, ElementRef, EventEmitter, Input, OnInit, Output, ViewChild} from '@angular/core';

@Component({
  selector: 'nodeGraph',
  templateUrl: './node-graph.component.html',
  styleUrls: ['./node-graph.component.css']
})
export class NodeGraphComponent implements OnInit {
  data: any;

  @ViewChild('graphSvg') graphSvg: ElementRef;

  @Output()
  nodeClick = new EventEmitter();

  @Output()
  nodeDblClick = new EventEmitter();

  @Input('graphData')
  set setData(value) {
    if (value && value.nodes && value.edges) {
      this.data = {
        nodes: Object.assign([], value.nodes),
        edges: Object.assign([], value.edges)
      };
      this.refresh();
    }
  }

  constructor() { }

  ngOnInit() {
  }

  refresh() {
    const linkDistance = 100;
    const nodeSize = 15;

    const colors = d3.scale.category10();

    const svg = d3.select('svg');
    svg.selectAll("*").remove();

    const force = d3.layout.force()
      .nodes(this.data.nodes)
      .links(this.data.edges)
      .linkDistance(linkDistance)
      .charge(-500)
      .theta(0.1)
      .gravity(0.05)
      .start();

    const edges = svg.selectAll('line')
      .data(this.data.edges)
      .enter()
      .append('line')
      .attr('id', (d, i) => 'edge' + i)
      .attr('marker-end', 'url(#arrowhead)')
      .style('stroke', '#ccc')
      .style('pointer-events', 'none');

    const nodes = svg.selectAll('circle')
      .data(this.data.nodes)
      .enter()
      .append('circle')
      .attr({'r': nodeSize})
      .style('fill', (d: any) => colors(d.group))
      .call(force.drag)
      .on("click", (node) => this.nodeClick.emit(node))
      .on("dblclick", (node) => this.nodeDblClick.emit(node));


    const nodelabels = svg.selectAll('.nodelabel')
      .data(this.data.nodes)
      .enter()
      .append('text')
      .attr({'x': (d: any) => d.x + nodeSize,
        'y': (d: any) => d.y - 4,
        'class': 'nodelabel',
        'stroke': 'black'})
      .text((d: any) => d.name);

    const edgepaths = svg.selectAll('.edgepath')
      .data(this.data.edges)
      .enter()
      .append('path')
      .attr({'d': (d: any) => 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y,
        'class': 'edgepath',
        'fill-opacity': 0,
        'stroke-opacity': 0,
        'fill': 'blue',
        'stroke': 'red',
        'id': (d, i) => 'edgepath' + i })
      .style('pointer-events', 'none');

    const edgelabels = svg.selectAll('.edgelabel')
      .data(this.data.edges)
      .enter()
      .append('text')
      .style('pointer-events', 'none')
      .attr({'class': 'edgelabel',
        'id': (d, i) => 'edgelabel' + i,
        'dx': linkDistance * 0.4,
        'dy': 0,
        'font-size': 10,
        'fill': '#aaa'});

    edgelabels.append('textPath')
      .attr('xlink:href', (d, i) => '#edgepath' + i)
      .style('pointer-events', 'none')
      .text((d: any, i) => d.label);


    svg.append('defs').append('marker')
      .attr({'id': 'arrowhead',
        'viewBox': '-0 -5 10 10',
        'refX': 25,
        'refY': 0,
        'orient': 'auto',
        'markerWidth': 10,
        'markerHeight': 10,
        'xoverflow': 'visible'})
      .append('svg:path')
      .attr('d', 'M 0,-5 L 10 ,0 L 0,5')
      .attr('fill', '#ccc')
      .attr('stroke', '#ccc');


    force.on('tick', () => {
      edges.attr({
        'x1': (d: any) => d.source.x,
        'y1': (d: any) => d.source.y,
        'x2': (d: any) => d.target.x,
        'y2': (d: any) => d.target.y
      });

      nodes.attr({
        'cx': (d: any) => d.x,
        'cy': (d: any) => d.y
      });

      nodelabels
        .attr('x', (d: any) => d.x + 4 + nodeSize)
        .attr('y', (d: any) => d.y + 4);

      edgepaths.attr('d', (d: any) => 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y);

      edgelabels.attr('transform', function(d: any, i) {
        if (d.target.x < d.source.x) {
          const bbox = this.getBBox();
          const rx = bbox.x + bbox.width / 2;
          const ry = bbox.y + bbox.height / 2;
          return 'rotate(180 ' + rx + ' ' + ry + ')';
        } else {
          return 'rotate(0)';
        }
      });
    });

    this.onResize(svg, force);
    d3.select(window).on('resize', () => this.onResize(svg, force));
  }

  onResize(svg: any, force: any) {
    const computedStyle = window.getComputedStyle(this.graphSvg.nativeElement.parentElement.parentElement);
    const hPadding = parseFloat(computedStyle.paddingLeft) + parseFloat(computedStyle.paddingRight) + 5;
    const width = parseFloat(computedStyle.width) - hPadding;
    const vPadding = parseFloat(computedStyle.paddingTop) + parseFloat(computedStyle.paddingBottom) + 5;
    const height = parseFloat(computedStyle.height) - vPadding;
    svg.attr('width', width).attr('height', height);
    force.size([width, height]).resume();
  }
}
