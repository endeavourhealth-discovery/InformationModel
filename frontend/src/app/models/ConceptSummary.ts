import {DbEntity} from './DbEntity';
import {ConceptStatus} from './ConceptStatus';

export class ConceptSummary extends DbEntity {
  context: string;
  status: ConceptStatus;
  version: string;
}
