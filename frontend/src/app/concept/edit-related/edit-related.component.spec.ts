import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EditRelatedComponent } from './edit-related.component';

describe('EditRelatedComponent', () => {
  let component: EditRelatedComponent;
  let fixture: ComponentFixture<EditRelatedComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EditRelatedComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EditRelatedComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
