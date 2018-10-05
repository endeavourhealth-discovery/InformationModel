import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {RelatedEditorComponent} from './related-editor.component';

describe('RelatedEditor', () => {
  let component: RelatedEditorComponent
  let fixture: ComponentFixture<RelatedEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RelatedEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RelatedEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
