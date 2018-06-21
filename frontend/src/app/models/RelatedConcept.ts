import {ConceptSummary} from './ConceptSummary';
import {ConceptReference} from './ConceptReference';
import {DbEntity} from './DbEntity';

export class RelatedConcept extends DbEntity {
  sourceId: number;
  source: ConceptSummary;
  targetId: number;
  target: ConceptSummary;
  relationship: ConceptReference;
  order: number;
  mandatory: boolean;
  limit: number;
}
