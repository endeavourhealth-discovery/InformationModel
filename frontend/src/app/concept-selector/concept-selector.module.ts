import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {ConceptSelectorComponent} from './concept-selector/concept-selector.component';
import {ConceptSelectorService} from './concept-selector.service';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from '../../../node_modules/eds-angular4/dist/controls';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';

@NgModule({
  imports: [
    FormsModule,
    ControlsModule,
    NgbModule,
    CommonModule
  ],
  declarations: [ConceptSelectorComponent],
  providers: [ConceptSelectorService],
  entryComponents: [ConceptSelectorComponent],
  exports: [ConceptSelectorComponent]
})
export class ConceptSelectorModule { }
