import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GuidedHelpComponent } from './guided-help.component';

describe('GuidedHelpComponent', () => {
  let component: GuidedHelpComponent;
  let fixture: ComponentFixture<GuidedHelpComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ GuidedHelpComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(GuidedHelpComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
