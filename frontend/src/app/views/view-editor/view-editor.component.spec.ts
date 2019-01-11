import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewEditorComponent } from './view-editor.component';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {FormsModule} from '@angular/forms';
import {TreeModule} from 'angular-tree-component/dist/angular-tree-component';
import {ActivatedRoute, Params} from '@angular/router';
import {RouterTestingModule} from '@angular/router/testing';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {ViewService} from '../view.service';
import {HttpModule} from '@angular/http';

describe('ViewEditorComponent', () => {
  let component: ViewEditorComponent;
  let fixture: ComponentFixture<ViewEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        FormsModule,
        TreeModule,
        HttpModule,
        RouterTestingModule,
        NgbModule.forRoot(),
        ToastModule.forRoot()
      ],
      declarations: [ ViewEditorComponent ],
      providers: [
        LoggerService,
        ViewService,
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
    fixture = TestBed.createComponent(ViewEditorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
