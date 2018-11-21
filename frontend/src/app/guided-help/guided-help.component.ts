import {Component, ElementRef, OnInit, ViewChild} from '@angular/core';

@Component({
  selector: 'guided-help',
  templateUrl: './guided-help.component.html',
  styleUrls: ['./guided-help.component.css']
})
export class GuidedHelpComponent implements OnInit {
  @ViewChild("helpText") helpText: ElementRef;

  step: number = null;

  constructor() { }

  helpData: any = [
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
      let rect = element.getBoundingClientRect();
      document.body.appendChild(this.helpText.nativeElement);
      this.helpText.nativeElement.style.top = rect.top + 'px';
      let w = window.innerWidth;
      if (rect.left > (w/2))
        this.helpText.nativeElement.style.right = (w - rect.left) + 8 + 'px';
      else
        this.helpText.nativeElement.style.left = (rect.left + rect.width) + 'px';
      element.addEventListener(this.helpData[this.step].next, () =>this.next());
    }
  }

}
