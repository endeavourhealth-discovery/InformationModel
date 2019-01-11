import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NodeGraphDialogComponent } from './node-graph-dialog.component';
import {NodeGraphModule} from 'eds-angular4/dist/node-graph';
import {NgbModule, NgbActiveModal} from '@ng-bootstrap/ng-bootstrap';

describe('NodeGraphDialogComponent', () => {
  let component: NodeGraphDialogComponent;
  let fixture: ComponentFixture<NodeGraphDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        NodeGraphModule,
        NgbModule.forRoot()
      ],
      declarations: [ NodeGraphDialogComponent ],
      providers: [
        NgbActiveModal
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NodeGraphDialogComponent);
    component = fixture.componentInstance;
    component.nodeData = [];
    component.edgeData = [];
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
