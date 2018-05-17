import { BrowserModule } from '@angular/platform-browser';
import {NgModule} from '@angular/core';
import {RouterModule} from '@angular/router';

import {Http, HttpModule, RequestOptions, XHRBackend} from '@angular/http';
import {AppMenuService} from './app-menu.service';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {KeycloakService} from 'eds-angular4/dist/keycloak/keycloak.service';
import {keycloakHttpFactory} from 'eds-angular4/dist/keycloak/keycloak.http';
import {AbstractMenuProvider, DialogsModule, LayoutModule, LoggerModule} from 'eds-angular4';
import {LayoutComponent} from 'eds-angular4/dist/layout/layout.component';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {WorkflowManagerModule} from './workflow-manager/workflow-manager.module';
import {AttributeModelModule} from './attribute-model/attribute-model.module';
import {ConceptModule} from './concept/concept.module';

@NgModule({
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpModule,

    LayoutModule,
    LoggerModule,
    DialogsModule,

    WorkflowManagerModule,
    AttributeModelModule,
    ConceptModule,

    RouterModule.forRoot(AppMenuService.getRoutes(), {useHash: true}),
    NgbModule.forRoot(),
    ToastModule.forRoot()
  ],
  providers: [
    KeycloakService,
    { provide: Http, useFactory: keycloakHttpFactory, deps: [XHRBackend, RequestOptions, KeycloakService] },
    { provide: AbstractMenuProvider, useClass : AppMenuService }
  ],
  bootstrap: [LayoutComponent]
})
export class AppModule {}
