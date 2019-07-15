import {CodeableConcept} from './CodeableConcept';
import {Concept} from './Concept';

export class ConceptSelection extends CodeableConcept {
    id: string;
    excludeChildren: boolean;
    exclusions: Concept[];
}
