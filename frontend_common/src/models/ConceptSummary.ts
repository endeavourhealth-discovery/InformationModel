import {ConceptStatus} from './ConceptStatus';
import {Reference} from './Reference';

export class ConceptSummary {
  id: number;
  name: string;
  context: string;
  status: ConceptStatus;
  synonym: boolean;
  scheme: Reference;
}
