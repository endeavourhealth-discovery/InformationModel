import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SchemaMappingsEditorComponent } from './schema-mappings-editor.component';
import {ActivatedRoute, Params} from '@angular/router';
import {RouterTestingModule} from '@angular/router/testing';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {SchemaMappingsService} from '../schema-mappings.service';
import {HttpModule} from '@angular/http';

describe('SchemaMappingsEditComponent', () => {
  let component: SchemaMappingsEditorComponent;
  let fixture: ComponentFixture<SchemaMappingsEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        HttpModule,
        RouterTestingModule,
        NgbModule.forRoot(),
        ToastModule.forRoot()
      ],
      declarations: [ SchemaMappingsEditorComponent ],
      providers: [
        Location,
        LoggerService,
        SchemaMappingsService,
        { provide: ActivatedRoute, useValue: {
            params: {
              subscribe: (fn: (value: Params) => void) => fn({id: 1, context: 'Observation'}),
            }
          }
        }
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SchemaMappingsEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
