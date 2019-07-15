import {CodeableConcept} from './CodeableConcept';

export class SearchResult {
    page: number;
    count: number;
    results: CodeableConcept[];
}
