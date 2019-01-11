import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TermMappingsEditorComponent } from './term-mappings-editor.component';
import {ActivatedRoute, Params} from '@angular/router';
import {RouterTestingModule} from '@angular/router/testing';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/src/toast.module';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../../concept/concept.service';
import {HttpModule} from '@angular/http';
import {TermMappingsService} from '../term-mappings.service';

describe('TermMappingsEditorComponent', () => {
  let component: TermMappingsEditorComponent;
  let fixture: ComponentFixture<TermMappingsEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        HttpModule,
        RouterTestingModule,
        NgbModule.forRoot(),
        ToastModule.forRoot()
      ],
      declarations: [ TermMappingsEditorComponent ],
      providers: [
        LoggerService,
        ConceptService,
        TermMappingsService,
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
    fixture = TestBed.createComponent(TermMappingsEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
