import {DbEntity} from './DbEntity';
import {ConceptStatus} from './ConceptStatus';
import {ConceptReference} from './ConceptReference';

export class AttributeModelSummary extends DbEntity {
  inherits: ConceptReference;
  context: string;
  status: ConceptStatus;
  version: string;
}
