import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RelationshipPickerComponent } from './relationship-picker.component';

describe('RelationshipPickerComponent', () => {
  let component: RelationshipPickerComponent;
  let fixture: ComponentFixture<RelationshipPickerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RelationshipPickerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RelationshipPickerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
