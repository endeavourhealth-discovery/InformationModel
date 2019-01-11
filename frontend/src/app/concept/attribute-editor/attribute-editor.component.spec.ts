import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AttributeEditorComponent } from './attribute-editor.component';
import {FormsModule} from '@angular/forms';
import {NgbModule, NgbActiveModal} from '@ng-bootstrap/ng-bootstrap';
import {LoggerService} from 'eds-angular4';
import {ToastModule} from 'ng2-toastr/ng2-toastr';
import {Attribute} from '../../models/Attribute';
import {Reference} from 'im-common/dist/models/Reference';
import {HttpModule, XHRBackend} from '@angular/http';
import {MockBackend} from '@angular/http/testing';
import {ConceptService} from '../concept.service';

describe('AttributeEditorComponent', () => {
  let component: AttributeEditorComponent;
  let fixture: ComponentFixture<AttributeEditorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
        imports: [
          FormsModule,
          HttpModule,
          NgbModule.forRoot(),
          ToastModule.forRoot()
        ],
        providers: [
          NgbActiveModal,
          LoggerService,
          ConceptService,
          { provide: XHRBackend, useClass: MockBackend }
        ],
        declarations: [AttributeEditorComponent]
      })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AttributeEditorComponent);
    component = fixture.componentInstance;
    component.result = new Attribute();
    component.result.concept = new Reference();
    component.result.attribute = new Reference();
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should return literal false for no attribute result', () => {
    const actual = component.isLiteral();
    expect(actual).toBe(false);
  });
});
