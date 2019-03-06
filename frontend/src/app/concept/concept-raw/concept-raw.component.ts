import {AfterViewInit, Component, ElementRef, ViewChild} from '@angular/core';
import {NgbActiveModal, NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptService} from '../concept.service';
import {LoggerService} from 'eds-angular4';

@Component({
  selector: 'app-concept-raw',
  templateUrl: './concept-raw.component.html',
  styleUrls: ['./concept-raw.component.css']
})
export class ConceptRawComponent implements AfterViewInit {
  public static open(modal: NgbModal, concept: any) {
    const modalRef = modal.open(ConceptRawComponent, { backdrop: 'static', size: 'lg'});

    // Edit a copy
    let clone = Object.assign({}, concept);

    // Remove @id and @document to prevent manual overwriting
    modalRef.componentInstance.id = clone['@id'];
    modalRef.componentInstance.document = clone['@document'];
    delete clone['@id'];
    delete clone['@document'];

    let json = JSON.stringify(clone, null, 4);

    modalRef.componentInstance.json = json;

    return modalRef;
  }

  @ViewChild('textarea') textarea: ElementRef;
  json: string;
  id: string;
  document: string;
  documents: string[] = [];

  constructor(private dialog: ElementRef,
              private modal: NgbModal,
              private activeModal: NgbActiveModal,
              private conceptService: ConceptService,
              private logger: LoggerService) { }

  ngAfterViewInit(): void {
    if (this.textarea != null)
      this.textarea.nativeElement.focus();
    this.conceptService.getDocuments()
      .subscribe(
        (result) => this.documents = result,
        (error) => this.logger.error(error)
      );
  }

  validateClick() {
    this.validate(
      () => this.logger.success('Valid concept json'),
      (missingId) => this.highlightMissingId(missingId)
    );
  }

  validate(validCallback = null, invalidCallback = null) {
    try {
      let concept = JSON.parse(this.json);
      let ids: string[] = [];
      this.getIds(ids, concept);
      this.validateIds(ids, validCallback, invalidCallback);
    } catch (e) {
      this.logger.error(e);
      let i = e.toString().indexOf("at position");
      if (i > -1) {
        let p = e.toString().substr(i + 12);
        this.textarea.nativeElement.focus();
        this.textarea.nativeElement.selectionEnd = p;
      }
    }
  }

  getIds(ids: string[], node: any) {
    if (node instanceof Object) {
      let keys = Object.keys(node);
      for (let key of keys) {
        if (node[key]['@id'] != null)
          ids.push(node[key]['@id']);
        else
          this.getIds(ids, node[key]);
      }
    }
  }

  validateIds(ids: string[], validCallback = null, invalidCallback = null) {
    this.conceptService.validateIds(ids)
      .subscribe(
        (result) => {
          if ((result == null || result == '') && validCallback != null)
            validCallback();
          if (result != null && result != '' && invalidCallback != null)
            invalidCallback(result);
        },
        (error) => this.logger.error(error)
      );
  }

  highlightMissingId(missingId: string) {
    this.logger.error('Referenced @id not known "' + missingId + '"')
    let i = this.json.indexOf(missingId);
    if (i > -1) {
      this.textarea.nativeElement.focus();
      this.textarea.nativeElement.selectionEnd = i;
    }
  }

  ok() {
    this.validate(
      () => {
        let result = JSON.parse(this.json);

        // Add @id and @document back in
        result['@id'] = this.id;
        result['@document'] = this.document;
        this.activeModal.close(result);
      },
      (missingId) => this.highlightMissingId(missingId)
    );
  }

  cancel() {
    this.activeModal.dismiss();
  }

}
