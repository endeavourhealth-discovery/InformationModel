import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TermMappingsComponent } from './term-mappings.component';
import { TermMappingsEditorComponent } from './term-mappings-editor/term-mappings-editor.component';
import {FormsModule} from '@angular/forms';

import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {TermMappingsService} from './term-mappings.service';

@NgModule({
  imports: [
    FormsModule,
    CommonModule,
    NgbModule
  ],
  declarations: [TermMappingsComponent, TermMappingsEditorComponent],
  providers: [TermMappingsService]
})
export class TermMappingsModule { }
