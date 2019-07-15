import {Concept} from './Concept';

export class CodeableConcept extends Concept {
    scheme: string;
    code: string;
}
