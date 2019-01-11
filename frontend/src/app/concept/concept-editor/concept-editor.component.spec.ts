import {async, ComponentFixture, inject, TestBed} from '@angular/core/testing';

import {NvD3Module} from 'ng2-nvd3';
import 'd3';
import 'nvd3';
import { ConceptEditorComponent } from './concept-editor.component';
import {FormsModule} from '@angular/forms';
import {CommonModule} from '@angular/common';
import {NodeGraphModule} from 'eds-angular4/dist/node-graph';
import {RouterTestingModule} from '@angular/router/testing';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {ModuleStateService} from 'eds-angular4/dist/common';
import {HttpModule, ResponseOptions, XHRBackend} from '@angular/http';
import {MockBackend} from '@angular/http/testing';
import {ConceptService} from '../concept.service';
import {Concept} from 'im-common/dist/models/Concept';
import {ActivatedRoute, Params} from '@angular/router';

describe('ConceptEditorComponent', () => {
  let component: ConceptEditorComponent;
  let fixture: ComponentFixture<ConceptEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
        imports: [
          FormsModule,
          CommonModule,
          NvD3Module,
          NodeGraphModule,
          RouterTestingModule,
          HttpModule,
          NgbModule.forRoot(),
          ToastModule.forRoot()
        ],
      declarations: [ ConceptEditorComponent ],
      providers: [
        LoggerService,
        ModuleStateService,
        ConceptService,
        { provide: XHRBackend, useClass: MockBackend },
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
    fixture = TestBed.createComponent(ConceptEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', inject([ConceptService, XHRBackend], (conceptService, mockBackend) => {

    mockBackend.connections.subscribe((connection) => {
      if (connection.request.url === 'api/Concept/1') {
        connection.mockRespond(new Response(new ResponseOptions({
          body: JSON.stringify(new Concept())
        })));
      } else if (connection.request.url === 'api/Concept/1/Attribute') {
        connection.mockRespond(new Response(new ResponseOptions({
          body: JSON.stringify([])
        })));
      } else if (connection.request.url === 'api/Concept/1/Synonyms') {
        connection.mockRespond(new Response(new ResponseOptions({
          body: JSON.stringify([])
        })));
      } else {
        throw new Error('Unknown URL: ' + connection.request.url);
      }

    });

    expect(component).toBeTruthy();
  }));
});
