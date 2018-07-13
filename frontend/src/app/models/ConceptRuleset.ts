import {DbEntity} from './DbEntity';
import {ConceptRule} from './ConceptRule';
import {ConceptReference} from './ConceptReference';

export class ConceptRuleset extends DbEntity {
  conceptId: number;
  target: ConceptReference;
  resourceType: string;
  order: number;
  rules: ConceptRule[];
}
