import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import {SynonymEditorComponent} from './synonym-editor.component';

describe('SynonymEditorComponent', () => {
  let component: SynonymEditorComponent;
  let fixture: ComponentFixture<SynonymEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SynonymEditorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SynonymEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
