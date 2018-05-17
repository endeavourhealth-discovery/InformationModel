import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AttributeModelComponent } from './attribute-model.component';
import { AttributeModelEditorComponent } from './attribute-model-editor/attribute-model-editor.component';
import {FormsModule} from '@angular/forms';
import {NvD3Module} from 'ng2-nvd3';

import 'd3';
import 'nvd3';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {NodeGraphModule} from '../node-graph/node-graph.module';
import {AttributeModelService} from './attribute-model.service';

@NgModule({
  imports: [
    FormsModule,
    CommonModule,
    NvD3Module,
    NgbModule,
    NodeGraphModule
  ],
  declarations: [AttributeModelComponent, AttributeModelEditorComponent],
  providers: [AttributeModelService]
})
export class AttributeModelModule { }
