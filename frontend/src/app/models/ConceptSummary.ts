import {DbEntity} from './DbEntity';
import {ConceptStatus} from './ConceptStatus';

export class ConceptSummary extends DbEntity {
  context: string;
  name: string;
  status: ConceptStatus = ConceptStatus.DRAFT;
  version: string = "0.1";
}
