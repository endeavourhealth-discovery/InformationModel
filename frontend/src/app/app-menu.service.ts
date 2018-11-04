import {Injectable} from '@angular/core';
import {AbstractMenuProvider} from 'eds-angular4';
import {MenuOption} from 'eds-angular4/dist/layout/models/MenuOption';
import {Routes} from '@angular/router';
import {WorkflowManagerComponent} from './workflow-manager/workflow-manager.component';
import {ConceptLibraryComponent} from './concept/concept-library.component';
import {TermMappingsComponent} from './term-mappings/term-mappings.component';
import {TermMappingsEditorComponent} from './term-mappings/term-mappings-editor/term-mappings-editor.component';
import {ConceptEditorComponent} from './concept/concept-editor/concept-editor.component';
import {ViewLibraryComponent} from './views/view-library.component';
import {ViewEditorComponent} from './views/view-editor/view-editor.component';

export class DummyComponent {}

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      { path: '', redirectTo : 'conceptLibrary', pathMatch: 'full' },  // Default route
      { path: 'conceptLibrary', component: ConceptLibraryComponent },
      { path: 'concept/:id', component: ConceptEditorComponent },
      { path: 'concept/:id/:context', component: ConceptEditorComponent },
      { path: 'viewLibrary', component: ViewLibraryComponent },
      { path: 'view/:id', component: ViewEditorComponent },
      { path: 'view/:id/:name', component: ViewEditorComponent },
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
      {caption: 'Views library', state: 'viewLibrary', icon: 'fa fa-eye'},
      {caption: 'Workflow manager', state: 'workflowManager', icon: 'fa fa-code-fork', role: 'eds-info-manager:workflow'},
      {caption: 'Term mappings', state: 'termMappings', icon: 'fa fa-code', role: 'eds-info-manager:termMappings'}
    ];
  }

  useUserManagerForRoles(): boolean {
    return false;
  }
}
