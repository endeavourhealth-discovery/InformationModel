import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SchemaMappingsEditorComponent } from './schema-mappings-editor.component';

describe('SchemaMappingsEditComponent', () => {
  let component: SchemaMappingsEditorComponent;
  let fixture: ComponentFixture<SchemaMappingsEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SchemaMappingsEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SchemaMappingsEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
