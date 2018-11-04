import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ViewLibraryComponent } from './view-library.component';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {FormsModule} from '@angular/forms';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {ViewService} from './view.service';
import { ViewEditorComponent } from './view-editor/view-editor.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ControlsModule,
    NgbModule,
  ],
  declarations: [ViewLibraryComponent, ViewEditorComponent],
  providers: [ViewService]
})
export class ViewsModule { }
