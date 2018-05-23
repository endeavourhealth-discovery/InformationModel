import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TermMappingsComponent } from './term-mappings.component';
import { TermMappingsEditorComponent } from './term-mappings-editor/term-mappings-editor.component';
import {FormsModule} from '@angular/forms';
import {NvD3Module} from 'ng2-nvd3';

import 'd3';
import 'nvd3';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {NodeGraphModule} from '../node-graph/node-graph.module';
import {TermMappingsService} from './term-mappings.service';

@NgModule({
  imports: [
    FormsModule,
    CommonModule,
    NvD3Module,
    NgbModule,
    NodeGraphModule
  ],
  declarations: [TermMappingsComponent, TermMappingsEditorComponent],
  providers: [TermMappingsService]
})
export class TermMappingsModule { }
