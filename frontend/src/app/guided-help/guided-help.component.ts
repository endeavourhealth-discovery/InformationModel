import {Component, ElementRef, Input, OnInit, ViewChild} from '@angular/core';

@Component({
  selector: 'guided-help',
  templateUrl: './guided-help.component.html',
  styleUrls: ['./guided-help.component.css']
})
export class GuidedHelpComponent implements OnInit {
  @Input("section") section: String;
  @ViewChild("helpText") helpText: ElementRef;

  step: number = null;
  helpData: any = [];

  constructor() { }

  conceptLibraryHelp = [
    {
      selector: '#addConcept',
      text: 'Click the "Add" button',
      next: 'click'
    },
    {
      selector: '#conceptContext',
      text: 'Type a context name, e.g. "RecordType.Observation"',
      next: 'focusout'
    },
    {
      selector: '#promptSuperclass',
      text: 'Pick the supertype',
      next: 'click'
    },
    {
      selector: '[name="filter"]',
      text: 'Type search text, e.g. "RecordType" then press Enter',
      next: 'focusout'
    },
    {
      selector: '.modal-dialog .btn-success',
      next: 'click',
      text: 'Enter a view name and click Create view'
    }
  ];

  viewLibraryHelp = [
    {
      selector: '#addBtn',
      next: 'click',
      text: 'Click the "Add" button'
    },
    {
      selector: '.modal-dialog .btn-success',
      next: 'click',
      text: 'Enter a view name and click Create view'
    }
  ];

  ngOnInit() {
  }

  startHelp() {
    if (this.section == 'ConceptLibrary')
      this.helpData = this.conceptLibraryHelp;
    else
      this.helpData = this.viewLibraryHelp;

    this.step = 0;
    this.updateHelp();
  }

  next() {
    if (this.step == this.helpData.length - 1)
      this.step = null;
    else {
      this.step++;
      this.updateHelp();
    }
  }

  updateHelp() {
    let targets = document.querySelectorAll(this.helpData[this.step].selector);
    if (targets.length == 1) {
      let element = targets[0];
      element.focus();
      let rect = element.getBoundingClientRect();
      document.body.appendChild(this.helpText.nativeElement);
      this.helpText.nativeElement.style.top = rect.top + 'px';
      let w = window.innerWidth;
      if (rect.left > (w/2)) {
        this.helpText.nativeElement.style.right = (w - rect.left) + 8 + 'px';
        this.helpText.nativeElement.style.left = null;
      } else {
        this.helpText.nativeElement.style.left = (rect.left + rect.width) + 'px';
        this.helpText.nativeElement.style.right = null;
      }
      element.addEventListener(this.helpData[this.step].next, () =>this.next());
    }
  }

}
