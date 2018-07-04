import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ValueSummaryComponent } from './value-summary.component';

describe('ValueSummaryComponent', () => {
  let component: ValueSummaryComponent;
  let fixture: ComponentFixture<ValueSummaryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ValueSummaryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ValueSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
