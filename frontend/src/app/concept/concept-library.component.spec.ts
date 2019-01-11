import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import { ConceptLibraryComponent } from './concept-library.component';
import {CommonModule} from '@angular/common';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {RouterTestingModule} from '@angular/router/testing';
import {ConceptService} from './concept.service';
import {HttpModule} from '@angular/http';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';

describe('ConceptLibraryComponent', () => {
  let component: ConceptLibraryComponent;
  let fixture: ComponentFixture<ConceptLibraryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        CommonModule,
        FormsModule,
        ControlsModule,
        RouterTestingModule,
        HttpModule,
        NgbModule.forRoot(),
        ToastModule.forRoot()
      ],
      declarations: [ ConceptLibraryComponent ],
      providers: [
        ConceptService,
        LoggerService
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ConceptLibraryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
