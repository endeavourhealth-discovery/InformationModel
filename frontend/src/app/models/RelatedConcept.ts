import {ConceptSummary} from './ConceptSummary';
import {ConceptReference} from './ConceptReference';

export class RelatedConcept {
  id: number;
  sourceId: number;
  source: ConceptSummary;
  targetId: number;
  target: ConceptSummary;
  relationship: ConceptReference;
  order: number;
  mandatory: boolean;
  limit: number;
}
