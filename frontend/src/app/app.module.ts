import { BrowserModule } from '@angular/platform-browser';
import {NgModule} from '@angular/core';
import {RouterModule} from '@angular/router';

import {Http, HttpModule, RequestOptions, XHRBackend} from '@angular/http';
import {AppMenuService} from './app-menu.service';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {KeycloakService} from 'eds-angular4/dist/keycloak/keycloak.service';
import {keycloakHttpFactory} from 'eds-angular4/dist/keycloak/keycloak.http';
import {AbstractMenuProvider, DialogsModule, LayoutModule, LoggerModule, UserManagerNotificationService} from 'eds-angular4';
import {LayoutComponent} from 'eds-angular4/dist/layout/layout.component';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {ConceptModule} from './concept/concept.module';
import {ModuleStateService} from 'eds-angular4/dist/common';
import {WorkflowManagerModule} from './workflow-manager/workflow-manager.module';
import {TermMappingsModule} from './term-mappings/term-mappings.module';
import {ViewsModule} from './views/views.module';

@NgModule({
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpModule,

    LayoutModule,
    LoggerModule,
    DialogsModule,

    ConceptModule,
    ViewsModule,
    WorkflowManagerModule,
    TermMappingsModule,

    RouterModule.forRoot(AppMenuService.getRoutes(), {useHash: true}),
    NgbModule.forRoot(),
    ToastModule.forRoot()
  ],
  providers: [
    KeycloakService,
    ModuleStateService,
    { provide: AbstractMenuProvider, useClass : AppMenuService },
    { provide: Http, useFactory: keycloakHttpFactory, deps: [XHRBackend, RequestOptions, KeycloakService, AbstractMenuProvider, UserManagerNotificationService] }
  ],
  bootstrap: [LayoutComponent]
})
export class AppModule {}
