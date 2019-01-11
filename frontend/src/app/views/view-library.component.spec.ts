import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewLibraryComponent } from './view-library.component';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {RouterTestingModule} from '@angular/router/testing';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {ViewService} from './view.service';
import {HttpModule} from '@angular/http';

describe('ViewLibraryComponent', () => {
  let component: ViewLibraryComponent;
  let fixture: ComponentFixture<ViewLibraryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        FormsModule,
        HttpModule,
        ControlsModule,
        RouterTestingModule,
        NgbModule.forRoot(),
        ToastModule.forRoot()
      ],
      declarations: [ ViewLibraryComponent ],
      providers: [
        LoggerService,
        ViewService
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ViewLibraryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
