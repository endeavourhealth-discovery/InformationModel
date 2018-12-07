import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SchemaMappingsComponent } from './schema-mappings.component';
import {SchemaMappingsService} from './schema-mappings.service';
import {ControlsModule} from 'eds-angular4/dist/controls';
import { SchemaMappingsEditorComponent } from './schema-mappings-editor/schema-mappings-editor.component';

@NgModule({
  imports: [
    CommonModule,
    ControlsModule
  ],
  declarations: [SchemaMappingsComponent, SchemaMappingsEditorComponent],
  providers: [SchemaMappingsService]
})
export class SchemaMappingsModule { }
