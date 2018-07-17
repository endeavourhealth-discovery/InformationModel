import {ConceptReference} from './ConceptReference';
import {Concept} from './Concept';

export class CalculationResult {
  status: number;
  stackTrace: ConceptReference[];
  result: Concept;
}
