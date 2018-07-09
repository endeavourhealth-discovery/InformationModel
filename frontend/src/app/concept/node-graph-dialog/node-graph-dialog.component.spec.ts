import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NodeGraphDialogComponent } from './node-graph-dialog.component';

describe('NodeGraphDialogComponent', () => {
  let component: NodeGraphDialogComponent;
  let fixture: ComponentFixture<NodeGraphDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NodeGraphDialogComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NodeGraphDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
