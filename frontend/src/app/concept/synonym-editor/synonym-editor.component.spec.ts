import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import {SynonymEditorComponent} from './synonym-editor.component';
import {NgbActiveModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {ConceptService} from '../concept.service';
import {HttpModule} from '@angular/http';
import {ActivatedRoute, Params} from '@angular/router';

describe('SynonymEditorComponent', () => {
  let component: SynonymEditorComponent;
  let fixture: ComponentFixture<SynonymEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        HttpModule,
        ToastModule.forRoot()
      ],
      declarations: [ SynonymEditorComponent ],
      providers: [
        NgbActiveModal,
        LoggerService,
        ConceptService,
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
    fixture = TestBed.createComponent(SynonymEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
