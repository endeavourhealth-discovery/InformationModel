import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewItemSelectorComponent } from './view-item-selector.component';

describe('ViewItemSelectorComponent', () => {
  let component: ViewItemSelectorComponent;
  let fixture: ComponentFixture<ViewItemSelectorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ViewItemSelectorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ViewItemSelectorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
