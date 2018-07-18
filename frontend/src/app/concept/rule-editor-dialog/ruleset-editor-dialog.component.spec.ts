import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RulesetEditorDialogComponent } from './ruleset-editor-dialog.component';

describe('RuleEditorComponent', () => {
  let component: RulesetEditorDialogComponent;
  let fixture: ComponentFixture<RulesetEditorDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RulesetEditorDialogComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RulesetEditorDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
