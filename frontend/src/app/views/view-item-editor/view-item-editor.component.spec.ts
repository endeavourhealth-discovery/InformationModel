import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewItemEditorComponent } from './view-item-editor.component';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {NgbModule, NgbActiveModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {ConceptService} from '../../concept/concept.service';
import {HttpModule} from '@angular/http';
import {Concept} from 'im-common/dist/models/Concept';

describe('ViewItemEditorComponent', () => {
  let component: ViewItemEditorComponent;
  let fixture: ComponentFixture<ViewItemEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        FormsModule,
        ControlsModule,
        HttpModule,
        NgbModule.forRoot(),
        ToastModule.forRoot()
      ],
      declarations: [ ViewItemEditorComponent ],
      providers: [
        LoggerService,
        NgbActiveModal,
        ConceptService
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ViewItemEditorComponent);
    component = fixture.componentInstance;
    component.concept = new Concept();
    component.concept.id = 1;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
