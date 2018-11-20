import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ConceptService} from './concept.service';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {ConceptLibraryComponent} from './concept-library.component';
import {ConceptEditorComponent} from './concept-editor/concept-editor.component';
import {NodeGraphModule} from 'eds-angular4/dist/node-graph';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {NvD3Module} from 'ng2-nvd3';
import { NodeGraphDialogComponent } from './node-graph-dialog/node-graph-dialog.component';
import {AttributeEditorComponent} from './attribute-editor/attribute-editor.component';
import {RelatedEditorComponent} from './related-editor/related-editor.component';
import {SynonymEditorComponent} from './synonym-editor/synonym-editor.component';
import {ConceptSelectorModule} from 'im-common';
import { ConceptCreateComponent } from './concept-create/concept-create.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ControlsModule,
    NgbModule,
    NvD3Module,
    NodeGraphModule,
    ConceptSelectorModule
  ],
  declarations: [
    ConceptLibraryComponent,
    ConceptEditorComponent,
    NodeGraphDialogComponent,
    AttributeEditorComponent,
    RelatedEditorComponent,
    SynonymEditorComponent,
    ConceptCreateComponent
  ],
  entryComponents: [
    NodeGraphDialogComponent,
    AttributeEditorComponent,
    RelatedEditorComponent,
    SynonymEditorComponent,
    ConceptCreateComponent
  ],
  providers: [ConceptService]
})
export class ConceptModule { }
