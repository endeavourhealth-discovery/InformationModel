import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ConceptPickerComponent } from './concept-picker/concept-picker.component';
import {ConceptService} from './concept.service';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {ConceptLibraryComponent} from './concept-library.component';
import {ConceptEditorComponent} from './concept-editor/concept-editor.component';
import {NodeGraphModule} from 'eds-angular4/dist/node-graph';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {NvD3Module} from 'ng2-nvd3';
import { ConceptDetailsComponent } from './concept-details/concept-details.component';
import { EditRelatedComponent } from './edit-related/edit-related.component';
import { NodeGraphDialogComponent } from './node-graph-dialog/node-graph-dialog.component';
import { TestResultDialogComponent } from './test-result-dialog/test-result-dialog.component';
import { RulesetEditorDialogComponent } from './rule-editor-dialog/ruleset-editor-dialog.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ControlsModule,
    NgbModule,
    NvD3Module,
    NodeGraphModule
  ],
  declarations: [ConceptPickerComponent, ConceptLibraryComponent, ConceptEditorComponent, ConceptDetailsComponent, EditRelatedComponent, NodeGraphDialogComponent, TestResultDialogComponent, RulesetEditorDialogComponent],
  entryComponents: [ConceptPickerComponent, EditRelatedComponent, NodeGraphDialogComponent, TestResultDialogComponent, RulesetEditorDialogComponent],
  providers: [ConceptService]
})
export class ConceptModule { }
