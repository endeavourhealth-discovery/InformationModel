import { Component, OnInit } from '@angular/core';
import {LoggerService} from 'eds-angular4';
import {Router} from '@angular/router';
import {ConceptService} from './concept.service';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {StatusHelper} from '../models/Status';
import {SearchResult} from '../models/SearchResult';
import {OntoSelectorComponent} from '../onto-selector/onto-selector/onto-selector.component';
import {ConceptSelectorComponent} from 'im-common/dist/concept-selector/concept-selector/concept-selector.component';
import {ViewItemSelectorComponent} from 'im-common/dist/view-item-selector/view-item-selector/view-item-selector.component';

@Component({
  selector: 'app-concept-library',
  templateUrl: './concept-library.component.html',
  styleUrls: ['./concept-library.component.css']
})
export class ConceptLibraryComponent implements OnInit {
  getStatusName = StatusHelper.getName;
  listTitle = 'Most recently used';
  summaryList: SearchResult;
  searchTerm: string;



  constructor(private router: Router,
              private modal: NgbModal,
              private conceptService: ConceptService,
              private log: LoggerService
  ) { }

  ngOnInit() {
  }

  addConcept(multiSelect: boolean) {
    ConceptSelectorComponent.open(this.modal, null, multiSelect)
      .result.then(
      (result) => {
        this.log.success(result, result, 'IM concept selected')
      }
    )
  }

  pickViewItem() {
    ViewItemSelectorComponent.open(this.modal, 'View.RecordModel', [])
      .result.then(
      (result) => this.log.success(result, result, 'View item selected'),
      (error) => this.log.error(error)
    )
  }

  searchOnto() {
    OntoSelectorComponent.open(this.modal)
      .result.then(
      (result) => {
        this.log.success(result, result, 'Onto code selected')
      }
    );
  }

  search() {}

  clear() {}
}
