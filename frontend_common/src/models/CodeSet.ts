import {CodeableConcept} from './CodeableConcept';

export class CodeSet {
    dbid: number;
    name: string;
    description: string;
    inclusions: CodeableConcept[];
    exclusions: CodeableConcept[];
}
