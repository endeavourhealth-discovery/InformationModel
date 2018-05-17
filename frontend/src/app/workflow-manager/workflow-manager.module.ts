import { NgModule } from '@angular/core';
import { WorkflowManagerComponent } from './workflow-manager.component';
import {WorkflowManagerService} from './workflow-manager.service';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {FormsModule} from '@angular/forms';
import {BrowserModule} from '@angular/platform-browser';
import {ControlsModule} from 'eds-angular4/dist/controls';

@NgModule({
  imports: [
    BrowserModule,
    FormsModule,
    NgbModule,
    ControlsModule,
  ],
  declarations: [WorkflowManagerComponent],
  providers: [WorkflowManagerService],
  entryComponents: []
})
export class WorkflowManagerModule { }
