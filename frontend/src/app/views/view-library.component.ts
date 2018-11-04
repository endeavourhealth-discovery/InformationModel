import { Component, OnInit } from '@angular/core';
import {View} from '../models/View';
import {ViewService} from './view.service';
import {InputBoxDialog, LoggerService} from 'eds-angular4';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Router} from '@angular/router';

@Component({
  selector: 'app-view-library',
  templateUrl: './view-library.component.html',
  styleUrls: ['./view-library.component.css']
})
export class ViewLibraryComponent implements OnInit {
  summaryList: View[];

  constructor(private modal: NgbModal, private router: Router, private log: LoggerService, private viewService: ViewService) { }

  ngOnInit() {
    this.viewService.getViews(500)  // Base folder concept
      .subscribe(
        (result) => this.summaryList = result,
        (error) => this.log.error(error)
      );
  }

  addView() {
    InputBoxDialog.open(this.modal, 'Add view', 'View name', '','Add view', 'Cancel')
      .result.then(
      (result) => this.createView(result),
      (error) => this.log.error(error)
    );
  }

  createView(name: string) {
    this.router.navigate(['view', 'add', name]);
  }

  editView(view: View) {
    this.router.navigate(['view', view.id]);
  }

}
