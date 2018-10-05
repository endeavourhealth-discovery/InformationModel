import {Reference} from './Reference';
import {DbEntity} from './DbEntity';

export class RelatedConcept extends DbEntity {
  source: Reference;
  target: Reference;
  relationship: Reference;
  order: number;
  mandatory: boolean;
  limit: number;
}
