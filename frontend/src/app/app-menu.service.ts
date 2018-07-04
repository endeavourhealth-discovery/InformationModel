import {Injectable} from '@angular/core';
import {AbstractMenuProvider} from 'eds-angular4';
import {MenuOption} from 'eds-angular4/dist/layout/models/MenuOption';
import {Routes} from '@angular/router';
import {WorkflowManagerComponent} from './workflow-manager/workflow-manager.component';
import {ConceptLibraryComponent} from './concept/concept-library.component';
import {TermMappingsComponent} from './term-mappings/term-mappings.component';
import {TermMappingsEditorComponent} from './term-mappings/term-mappings-editor/term-mappings-editor.component';
import {ConceptEditorComponent} from './concept/concept-editor/concept-editor.component';
import {ValueSummaryComponent} from './value/value-summary/value-summary.component';
import {ValueEditorComponent} from './value/value-editor/value-editor.component';

export class DummyComponent {}

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      { path: '', redirectTo : 'conceptLibrary', pathMatch: 'full' },  // Default route
      { path: 'conceptLibrary', component: ConceptLibraryComponent },
      { path: 'concept/:id', component: ConceptEditorComponent },
      { path: 'valueLibrary', component: ValueSummaryComponent },
      { path: 'value/:id', component: ValueEditorComponent },
      { path: 'workflowManager', component: WorkflowManagerComponent },
      { path: 'termMappings', component: TermMappingsComponent },
      { path: 'termMappings/:id', component: TermMappingsEditorComponent },

      { path: 'eds-user-manager', component: DummyComponent },

    ];
  }

  getClientId(): string {
    return 'eds-info-manager';
  }

  getApplicationTitle(): string {
    return 'Information Model Manager';
  }

  getMenuOptions(): MenuOption[] {
    return [
      {caption: 'Concept library', state: 'conceptLibrary', icon: 'fa fa-lightbulb-o', role: 'eds-info-manager:conceptLibrary'},
      {caption: 'Value library', state: 'valueLibrary', icon: 'fa fa-cubes', role: 'eds-info-manager:valueLibrary'},
      {caption: 'Workflow manager', state: 'workflowManager', icon: 'fa fa-code-fork', role: 'eds-info-manager:workflow'},
      {caption: 'Term mappings', state: 'termMappings', icon: 'fa fa-code', role: 'eds-info-manager:termMappings'}
    ];
  }
}
