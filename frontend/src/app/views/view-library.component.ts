import { Component, OnInit } from '@angular/core';
import {View} from '../models/View';
import {ViewService} from './view.service';
import {InputBoxDialog, LoggerService, MessageBoxDialog} from 'eds-angular4';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {Router} from '@angular/router';

@Component({
  selector: 'app-view-library',
  templateUrl: './view-library.component.html',
  styleUrls: ['./view-library.component.css']
})
export class ViewLibraryComponent implements OnInit {
  viewList: View[];

  constructor(private modal: NgbModal, private router: Router, private log: LoggerService, private viewService: ViewService) { }

  ngOnInit() {
    this.viewService.getViews()  // Base folder concept
      .subscribe(
        (result) => this.viewList = result,
        (error) => this.log.error(error)
      );
  }

  addView() {
    InputBoxDialog.open(this.modal, 'Create view', 'Enter name for new view', 'New view', 'Create view', 'Cancel')
      .result.then(
      (result) => this.viewService.save({id: null, name: result} as View)
        .subscribe(
          (result) => this.router.navigate(['view', result.id]),
          (error) => this.log.error(error)
        )
    );
  }

  editView(view: View) {
    this.router.navigate(['view', view.id]);
  }

  deleteView(view: View) {
    MessageBoxDialog.open(this.modal, 'Delete view', 'Are you sure you want to delete <b><i>'+view.name+'</i></b>?', 'Delete view', 'Cancel')
      .result.then(
      (confirm) => {
        this.viewService.delete(view.id)
          .subscribe(
            (result) => {
              this.log.success('Delete successful', view, 'Delete view');
              this.ngOnInit();
            },
                (error) => this.log.error(error)
          )
      }
    );
  }

}
