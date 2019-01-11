import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { WorkflowManagerComponent } from './workflow-manager.component';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {FormsModule} from '@angular/forms';
import {WorkflowManagerService} from './workflow-manager.service';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {HttpModule} from '@angular/http';
import {RouterTestingModule} from '@angular/router/testing';
import {ModuleStateService} from 'eds-angular4/dist/common';

describe('WorkflowManagerComponent', () => {
  let component: WorkflowManagerComponent;
  let fixture: ComponentFixture<WorkflowManagerComponent>;

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
      declarations: [ WorkflowManagerComponent ],
      providers: [
        LoggerService,
        ModuleStateService,
        WorkflowManagerService,
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(WorkflowManagerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
