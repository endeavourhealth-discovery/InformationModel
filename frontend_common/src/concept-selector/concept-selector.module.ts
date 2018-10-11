import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {ConceptSelectorComponent} from './concept-selector/concept-selector.component';
import {ConceptSelectorService} from './concept-selector.service';
import {FormsModule} from '@angular/forms';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {LoggerModule} from 'eds-angular4';

@NgModule({
    imports: [
        FormsModule,
        ControlsModule,
        NgbModule,
        CommonModule,
        LoggerModule
    ],
    declarations: [ConceptSelectorComponent],
    providers: [ConceptSelectorService],
    entryComponents: [ConceptSelectorComponent],
    exports: [ConceptSelectorComponent]
})
export class ConceptSelectorModule {
}
