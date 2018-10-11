import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ConceptSelectorComponent } from './concept-selector.component';

describe('ConceptSelectorComponent', () => {
  let component: ConceptSelectorComponent;
  let fixture: ComponentFixture<ConceptSelectorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ConceptSelectorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ConceptSelectorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
