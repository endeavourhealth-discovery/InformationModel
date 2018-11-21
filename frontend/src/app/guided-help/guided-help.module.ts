import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {FormsModule} from '@angular/forms';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {TreeModule} from 'angular-tree-component';
import {GuidedHelpComponent} from './guided-help.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ControlsModule,
    NgbModule,
    TreeModule
  ],
  declarations: [GuidedHelpComponent],
  exports: [GuidedHelpComponent]
})
export class GuidedHelpModule { }
