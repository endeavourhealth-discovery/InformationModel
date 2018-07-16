import {Component, forwardRef, Input} from '@angular/core';
import {ConceptStatus, ConceptStatusHelper} from '../../models/ConceptStatus';
import {Concept} from '../../models/Concept';
import {ControlValueAccessor, NG_VALUE_ACCESSOR} from '@angular/forms';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {ConceptPickerComponent} from '../concept-picker/concept-picker.component';
import {LoggerService} from 'eds-angular4';

@Component({
  selector: 'app-concept-details',
  templateUrl: './concept-details.component.html',
  styleUrls: ['./concept-details.component.css'],
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => ConceptDetailsComponent),
    multi: true
  }]
})
export class ConceptDetailsComponent implements ControlValueAccessor {
  private changed = [];
  private touched = [];

  // Local enum instance
  ConceptStatus = ConceptStatus;

  @Input('readonly')
  readonly: boolean;

  model: Concept;

  constructor(private modal: NgbModal, private logger: LoggerService) {}

  getConceptStatusName(status: ConceptStatus): string {
    return ConceptStatusHelper.getName(status);
  }

  setStatus(status: ConceptStatus) {
    this.model.status = status;
  }

  touch() {
    this.touched.forEach(f => f());
  }

  writeValue(value: any): void {
    this.model = value;
  }

  registerOnChange(fn: any): void {
    this.changed.push(fn);
  }

  registerOnTouched(fn: any): void {
    this.touched.push(fn);
  }
}
