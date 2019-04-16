import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {OntoSelectorComponent} from './onto-selector/onto-selector.component';
import {OntoSelectorService} from './onto-selector.service';
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
    declarations: [OntoSelectorComponent],
    providers: [OntoSelectorService],
    entryComponents: [OntoSelectorComponent],
    exports: [OntoSelectorComponent]
})
export class OntoSelectorModule {
}
