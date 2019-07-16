import {CodeableConcept} from './CodeableConcept';

export class ConceptSelection extends CodeableConcept {
    id: string;
    name: string;
    single: boolean;
}
