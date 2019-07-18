import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {ViewItemSelectorService} from './view-item-selector.service';
import {FormsModule} from '@angular/forms';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {ControlsModule} from 'eds-angular4/dist/controls';
import {LoggerModule} from 'eds-angular4';
import {TreeModule} from "angular-tree-component";
import {ViewItemSelectorComponent} from './view-item-selector/view-item-selector.component';

@NgModule({
    imports: [
        FormsModule,
        ControlsModule,
        NgbModule,
        CommonModule,
        LoggerModule,
        TreeModule
    ],
    declarations: [ViewItemSelectorComponent],
    providers: [ViewItemSelectorService],
    entryComponents: [ViewItemSelectorComponent],
    exports: [ViewItemSelectorComponent]
})
export class ViewItemSelectorModule {
}
