import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AttributeModelEditorComponent } from './attribute-model-editor.component';

describe('AttributeModelEditorComponent', () => {
  let component: AttributeModelEditorComponent;
  let fixture: ComponentFixture<AttributeModelEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AttributeModelEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AttributeModelEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
