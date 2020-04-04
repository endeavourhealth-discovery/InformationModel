import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RecordModelLibraryComponent } from './record-model-library.component';

describe('RecordModelLibraryComponent', () => {
  let component: RecordModelLibraryComponent;
  let fixture: ComponentFixture<RecordModelLibraryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RecordModelLibraryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RecordModelLibraryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
