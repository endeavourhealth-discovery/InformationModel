import {AfterViewInit, Component} from '@angular/core';
import {ActivatedRoute} from '@angular/router';
import {LoggerService, MessageBoxDialog} from 'eds-angular4';
import {View} from '../../models/View';
import {ViewService} from '../view.service';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Location} from '@angular/common';
import {ViewFolder} from '../../models/ViewFolder';
import {ConceptSummary} from '../../models/ConceptSummary';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {Concept} from '../../models/Concept';

@Component({
  selector: 'app-view-editor',
  templateUrl: './view-editor.component.html',
  styleUrls: ['./view-editor.component.css']
})
export class ViewEditorComponent implements AfterViewInit {
  viewFolder: ViewFolder = {} as ViewFolder;
  concepts: ConceptSummary[];

  constructor(private route: ActivatedRoute,
              private location: Location,
              private modal: NgbModal,
              private log: LoggerService,
              private viewService: ViewService) { }

  ngAfterViewInit() {
    this.route.params.subscribe(
      (params) => this.init(params['id'], params['name'])
    );
  }

  init(id: any, name: string) {
    if (id === 'add')
      setTimeout(() => this.newView(name));
    else
      this.loadView(id);
  }

  loadView(id: number) {
    this.viewService.get(id)
      .subscribe(
        (result) => {
          this.viewFolder.view = result;
          this.loadChildViews(this.viewFolder);
          this.loadChildConcepts(this.viewFolder);
        },
        (error) => this.log.error(error)
      );
  }

  newView(name: string) {
    this.viewFolder.view = {name: name} as View;
  }

  loadChildViews(folder: ViewFolder) {
    this.viewService.getViews(folder.view.id)
      .subscribe(
        (result) => folder.children = result.map((v) => ({view: v} as ViewFolder)),
        (error) => this.log.error(error)
      );
  }

  loadChildConcepts(folder: ViewFolder) {
    this.viewService.getConcepts(folder.view.id)
      .subscribe(
        (result) => this.concepts = result,
        (error) => this.log.error(error)
      );
  }

  addConcept() {
    ConceptSelectorComponent.open(this.modal)
      .result.then(
      (result) => this.addConceptSummary(result)
    );
  }

  addConceptSummary(concept: Concept) {
    let i = this.concepts.find((c) => c.id === concept.id);
    if (i == null) {
      this.concepts.push(
        {
          id: concept.id,
          name: concept.fullName,
          context: concept.context,
          status: concept.status,
          synonym: false
        }
      );
    }
  }

  save(close: boolean) {
    this.viewService.save(this.viewFolder.view)
      .subscribe(
        (result) => {
          this.viewFolder.view = result
          this.log.success('View saved', this.viewFolder.view, 'Saved');
          if (close)
            this.close(false)
        },
        (error) => this.log.error('Error during save', error, 'Save')
      );
  }

  close(withConfirm: boolean) {
    if (!withConfirm)
      this.location.back();
    else
      MessageBoxDialog.open(this.modal, 'Close concept editor', 'Unsaved changes will be lost.  Do you want to close the editor?', 'Close editor', 'Cancel')
        .result.then(
        (result) => this.location.back()
      )
  }
}
