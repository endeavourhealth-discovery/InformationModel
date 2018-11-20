import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewItemEditorComponent } from './view-item-editor.component';

describe('ViewItemEditorComponent', () => {
  let component: ViewItemEditorComponent;
  let fixture: ComponentFixture<ViewItemEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ViewItemEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ViewItemEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
