import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { WorkflowManagerComponent } from './workflow-manager.component';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {FormsModule} from '@angular/forms';
import {WorkflowManagerService} from './workflow-manager.service';
import {MockWorkflowManagerService} from '../mocks/mock.workflow-manager-service.service';

describe('WorkflowManagerComponent', () => {
  let component: WorkflowManagerComponent;
  let fixture: ComponentFixture<WorkflowManagerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [FormsModule, NgbModule.forRoot()],
      declarations: [ WorkflowManagerComponent ],
      providers: [
        {provide: WorkflowManagerService, useClass: MockWorkflowManagerService },
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
