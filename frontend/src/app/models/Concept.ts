import {ConceptSummary} from './ConceptSummary';
import {ConceptReference} from './ConceptReference';

export class Concept extends ConceptSummary {
  public type: ConceptReference = {id: 1, text: "Concept"};
  public url: string;
  public fullName: string;
  public description: string;
  public expression: string;
  public criteria: string;
}
