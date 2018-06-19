import {ConceptSummary} from './ConceptSummary';

export class RelatedConcept {
  id: number;
  sourceId: number;
  source: ConceptSummary;
  targetId: number;
  target: ConceptSummary;
  relationship: string;
  order: number;
  mandatory: boolean;
  limit: number;
}
