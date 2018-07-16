import {ConceptSummary} from './ConceptSummary';
import {ConceptReference} from './ConceptReference';

export class Concept extends ConceptSummary {
  public url: string;
  public description: string;
  public expression: string;
  public criteria: string;
}
