import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ValueSummaryComponent } from './value-summary/value-summary.component';
import {ValueService} from './value.service';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import { ValueEditorComponent } from './value-editor/value-editor.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ControlsModule
  ],
  declarations: [
    ValueSummaryComponent,
    ValueEditorComponent
  ],
  providers: [
    ValueService
  ]
})
export class ValueModule { }
