import {ConceptSummary} from './ConceptSummary';

export class Attribute {
  conceptId: number;
  attributeId: number;
  attribute: ConceptSummary;
  order: number;
  mandatory: boolean;
  limit: number;
}
