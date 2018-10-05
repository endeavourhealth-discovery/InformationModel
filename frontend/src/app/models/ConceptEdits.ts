import {Attribute} from './Attribute';
import {RelatedConcept} from './RelatedConcept';

export class ConceptEdits {
  public editedAttributes: Attribute[] = [];
  public deletedAttributes: Attribute[] = [];

  public editedRelated: RelatedConcept[] = [];
  public deletedRelated: RelatedConcept[] = [];
}
