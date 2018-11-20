import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {LoggerService} from 'eds-angular4';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Concept} from '../../models/Concept';
import {ViewItem} from '../../models/ViewItem';
import {Attribute} from '../../models/Attribute';
import {ConceptService} from '../../concept/concept.service';
import {ViewItemAddStyle} from '../../models/ViewItemAddStyle';

@Component({
  selector: 'app-view-item-editor',
  templateUrl: './view-item-editor.component.html',
  styleUrls: ['./view-item-editor.component.css']
})
export class ViewItemEditorComponent implements AfterViewInit {
  public static open(modal: NgbModal, viewFolder: ViewItem, concept: Concept) {
    const modalRef = modal.open(ViewItemEditorComponent, { backdrop: 'static', size: 'sm'});
    modalRef.componentInstance.viewFolder = viewFolder;
    modalRef.componentInstance.concept = concept;
    return modalRef;
  }

  viewFolder: ViewItem;
  concept: Concept;
  attributes: Attribute[];
  AddStyle = ViewItemAddStyle;
  addStyle: ViewItemAddStyle = ViewItemAddStyle.CONCEPT_ONLY;

  constructor(private modal: NgbModal,
              private activeModal: NgbActiveModal,
              private logger: LoggerService,
              private conceptService: ConceptService) { }

  @ViewChild('focus') focusField: ElementRef;
  ngAfterViewInit(): void {
    if (this.focusField != null)
      this.focusField.nativeElement.focus();

    this.conceptService.getAttributes(this.concept.id, false)
      .subscribe(
        (result) => this.attributes = result,
        (error) => this.logger.error(error)
      );
  }

  ok() {
    this.activeModal.close({
      addStyle: this.addStyle,
      attributes: this.attributes.filter(a => !(a as any).excluded)
    });
  }

  cancel() {
    this.activeModal.dismiss();
  }
}
