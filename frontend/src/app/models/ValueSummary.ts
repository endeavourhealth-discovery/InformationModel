import {ConceptReference} from './ConceptReference';
import {DbEntity} from './DbEntity';

export class ValueSummary extends DbEntity {
  name: string;
  concept: ConceptReference;
}
