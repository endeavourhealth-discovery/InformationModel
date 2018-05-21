import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TermMappingsEditorComponent } from './term-mappings-editor.component';

describe('AttributeModelEditorComponent', () => {
  let component: TermMappingsEditorComponent;
  let fixture: ComponentFixture<TermMappingsEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TermMappingsEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TermMappingsEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
