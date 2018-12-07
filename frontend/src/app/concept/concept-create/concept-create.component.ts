import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {ConceptService} from '../concept.service';
import {LoggerService} from 'eds-angular4';
import {Reference} from 'im-common/dist/models/Reference';
import {Concept} from 'im-common/dist/models/Concept';
import {ConceptStatus, ConceptStatusHelper} from 'im-common/dist/models/ConceptStatus';

@Component({
  selector: 'app-concept-create',
  templateUrl: './concept-create.component.html',
  styleUrls: ['./concept-create.component.css']
})
export class ConceptCreateComponent implements AfterViewInit {
  public static open(modal: NgbModal, commonSubtypes: Reference[], context: string = null) {
    const modalRef = modal.open(ConceptCreateComponent, { backdrop: 'static', size: 'lg'});
    modalRef.componentInstance.commonSubtypes = commonSubtypes;
    modalRef.componentInstance.concept.context = context;
    return modalRef;
  }

  commonSubtypes: Reference[] = [];
  context: string;
  concept: Concept = new Concept();

  // Enums/Helpers
  ConceptStatus = ConceptStatus;
  getConceptStatusName = ConceptStatusHelper.getName;

  constructor(private dialog: ElementRef,
              private modal: NgbModal,
              private activeModal: NgbActiveModal,
              private conceptService: ConceptService,
              private logger: LoggerService) { }

  @ViewChild('focus') focusField: ElementRef;
  ngAfterViewInit(): void {
    if (this.focusField != null)
      this.focusField.nativeElement.focus();
  }

  promptSuperclass() {
    this.hide();
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (result) => {
        this.show();
        this.concept.superclass = {id: result.id, name: result.fullName};
      },
      (cancel) => this.show()
    );
  }

  hide() {
    this.dialog.nativeElement.style.display = 'none';
  }

  show() {
    this.dialog.nativeElement.style.display = null;
  }

  ok() {
    this.conceptService.save(this.concept)
      .subscribe(
        (result) => this.activeModal.close(result),
        (error) => this.logger.error(error)
      );
  }

  cancel() {
    this.activeModal.dismiss();
  }

}