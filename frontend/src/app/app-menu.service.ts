import {Injectable} from '@angular/core';
import {AbstractMenuProvider} from 'eds-angular4';
import {MenuOption} from 'eds-angular4/dist/layout/models/MenuOption';
import {Routes} from '@angular/router';
import {WorkflowManagerComponent} from './workflow-manager/workflow-manager.component';
import {AttributeModelComponent} from './attribute-model/attribute-model.component';
import {AttributeModelEditorComponent} from './attribute-model/attribute-model-editor/attribute-model-editor.component';
import {ConceptLibraryComponent} from './concept/concept-library.component';
import {TermMappingsComponent} from './term-mappings/term-mappings.component';
import {TermMappingsEditorComponent} from './term-mappings/term-mappings-editor/term-mappings-editor.component';

export class DummyComponent {}

@Injectable()
export class AppMenuService implements  AbstractMenuProvider {
  static getRoutes(): Routes {
    return [
      { path: '', redirectTo : 'workflowManager', pathMatch: 'full' },  // Default route
      { path: 'workflowManager', component: WorkflowManagerComponent },
      { path: 'attributeModel', component: AttributeModelComponent },
      { path: 'attributeModel/:id', component: AttributeModelEditorComponent },
      { path: 'termMappings', component: TermMappingsComponent },
      { path: 'termMappings/:id', component: TermMappingsEditorComponent },
      { path: 'conceptLibrary', component: ConceptLibraryComponent },

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
      {caption: 'Workflow Manager', state: 'workflowManager', icon: 'fa fa-code-fork', role: 'eds-info-manager:workflow'},
      {caption: 'Attribute Models', state: 'attributeModel', icon: 'fa fa-sitemap', role: 'eds-info-manager:attributeModel'},
      {caption: 'Term Mappings', state: 'termMappings', icon: 'fa fa-code', role: 'eds-info-manager:termMappings'},
      {caption: 'Concept Library', state: 'conceptLibrary', icon: 'fa fa-lightbulb-o', role: 'eds-info-manager:conceptLibrary'}
    ];
  }
}
