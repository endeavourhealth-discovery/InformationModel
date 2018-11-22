import {Component, ElementRef, Input, OnInit, ViewChild} from '@angular/core';

@Component({
  selector: 'guided-help',
  templateUrl: './guided-help.component.html',
  styleUrls: ['./guided-help.component.css']
})
export class GuidedHelpComponent implements OnInit {
  @Input("section") section: String;
  @ViewChild("helpText") helpText: ElementRef;

  lastListener: any = null;
  step: number = null;
  helpData: any = {
    conceptLibraryHelp: [
      {
        selector: '#addConcept',
        text: 'Click the "Add" button',
        next: 'click'
      },
      {
        selector: '#conceptContext',
        text: 'Type a context name, e.g. "RecordType.Observation" then press <Tab>',
        next: 'focusout'
      },
      {
        selector: '#promptSuperclass',
        text: 'Pick the supertype',
        next: 'click'
      },
      {
        selector: '#conceptSelectorSearch',
        text: 'Type search text, e.g. "Record" then click Search',
        next: 'click'
      },
      {
        selector: '#selectConcept',
        next: 'click',
        text: 'Select a supertype, e.g. "Record Type" then click Select'
      }
    ],
    viewLibraryHelp: [
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
    ]
  };
  helpItem: any;

  constructor () {}

  ngOnInit() {
  }

  startHelp() {
    this.removeLastListener();

    if (this.section == 'ConceptLibrary')
      this.helpItem = this.helpData['conceptLibraryHelp'];
    else
      this.helpItem = this.helpData['viewLibraryHelp'];

    this.step = 0;
    this.updateHelp();
  }

  next() {
    let i = this.step;
    this.step = null;
    this.removeLastListener();
    if (this.step < this.helpItem.length)
    {
      setTimeout(() => {
        this.step = i+1;
        this.updateHelp();
      }, 500);
    }
  }

  updateHelp() {
    let targets = document.querySelectorAll(this.helpItem[this.step].selector);
    if (targets.length != 1) {
      // Cancel help
      this.step = null;
    } else {
      let element = targets[0];
      element.focus();
      let rect = element.getBoundingClientRect();
      document.body.appendChild(this.helpText.nativeElement);
      this.helpText.nativeElement.style.top = rect.top + 'px';
      let w = window.innerWidth;
      if (rect.left > (w / 2)) {
        this.helpText.nativeElement.style.right = (w - rect.left) + 8 + 'px';
        this.helpText.nativeElement.style.left = null;
      } else {
        this.helpText.nativeElement.style.left = (rect.left + rect.width) + 'px';
        this.helpText.nativeElement.style.right = null;
      }

      this.addListener(element, this.helpItem[this.step].next);
    }
  }

  addListener(element, type) {
    this.removeLastListener();
    this.lastListener = {
      element: element,
      type: type
    };
    this.lastListener.element.addEventListener(this.lastListener.type, () => this.next());
  }

  removeLastListener() {
    if (this.lastListener) {
      this.lastListener.element.removeEventListener(this.lastListener.type, () => this.next());
      this.lastListener = null;
    }
  }

}
