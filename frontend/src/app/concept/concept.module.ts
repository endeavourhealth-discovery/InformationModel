import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ConceptPickerComponent } from './concept-picker/concept-picker.component';
import {ConceptService} from './concept.service';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {ConceptLibraryComponent} from './concept-library.component';
import {ConceptEditorComponent} from './concept-editor/concept-editor.component';
import {NodeGraphModule} from '../node-graph/node-graph.module';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {NvD3Module} from 'ng2-nvd3';
import { ConceptDetailsComponent } from './concept-details/concept-details.component';
import { EditRelatedComponent } from './edit-related/edit-related.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ControlsModule,
    NvD3Module,
    NgbModule,
    NodeGraphModule
  ],
  declarations: [ConceptPickerComponent, ConceptLibraryComponent, ConceptEditorComponent, ConceptDetailsComponent, EditRelatedComponent],
  entryComponents: [ConceptPickerComponent, EditRelatedComponent],
  providers: [ConceptService]
})
export class ConceptModule { }
