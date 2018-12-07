import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SchemaMappingsComponent } from './schema-mappings.component';

describe('SchemaMappingsComponent', () => {
  let component: SchemaMappingsComponent;
  let fixture: ComponentFixture<SchemaMappingsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SchemaMappingsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SchemaMappingsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
