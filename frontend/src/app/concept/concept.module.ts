import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ConceptPickerComponent } from './concept-picker/concept-picker.component';
import {ConceptService} from './concept.service';
import {FormsModule} from '@angular/forms';
import {ControlsModule} from 'eds-angular4/dist/controls';
import { RelationshipPickerComponent } from './relationship-picker/relationship-picker.component';
import {ConceptLibraryComponent} from './concept-library.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ControlsModule
  ],
  declarations: [ConceptPickerComponent, RelationshipPickerComponent, ConceptLibraryComponent],
  entryComponents: [ConceptPickerComponent],
  providers: [ConceptService]
})
export class ConceptModule { }
