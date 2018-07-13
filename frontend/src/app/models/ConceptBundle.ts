import {Concept} from './Concept';
import {Attribute} from './Attribute';
import {RelatedConcept} from './RelatedConcept';
import {ConceptRuleset} from './ConceptRuleset';

export class ConceptBundle {
  concept: Concept;
  attributes: Attribute[];
  related: RelatedConcept[];
  ruleSets: ConceptRuleset[];
  deletedAttributeIds: number[];
  deletedRelatedIds: number[];
  deletedRuleSetIds: number[];
}
