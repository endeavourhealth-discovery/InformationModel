import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RuleEditorDialogComponent } from './rule-editor-dialog.component';

describe('RuleEditorComponent', () => {
  let component: RuleEditorDialogComponent;
  let fixture: ComponentFixture<RuleEditorDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RuleEditorDialogComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RuleEditorDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
