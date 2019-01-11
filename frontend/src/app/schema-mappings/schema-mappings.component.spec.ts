import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SchemaMappingsComponent } from './schema-mappings.component';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {SchemaMappingsService} from './schema-mappings.service';
import {HttpModule} from '@angular/http';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {RouterTestingModule} from '@angular/router/testing';

describe('SchemaMappingsComponent', () => {
  let component: SchemaMappingsComponent;
  let fixture: ComponentFixture<SchemaMappingsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        ControlsModule,
        HttpModule,
        RouterTestingModule,
        ToastModule.forRoot()
      ],
      declarations: [ SchemaMappingsComponent ],
      providers: [
        SchemaMappingsService,
        LoggerService
      ]
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
