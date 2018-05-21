import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TermMappingsComponent } from './term-mappings.component';

describe('TermMappingsComponent', () => {
  let component: TermMappingsComponent;
  let fixture: ComponentFixture<TermMappingsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TermMappingsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TermMappingsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
