import {Concept} from './Concept';
import {Attribute} from './Attribute';
import {RelatedConcept} from './RelatedConcept';

export class ConceptBundle {
  concept: Concept;
  attributes: Attribute[];
  related: RelatedConcept[];
  deletedAttributeIds: number[];
  deletedRelatedIds: number[];
}
