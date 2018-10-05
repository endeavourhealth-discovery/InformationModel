import {ConceptStatus} from './ConceptStatus';

export class ConceptSummary {
  id: number;
  name: string;
  context: string;
  status: ConceptStatus;
  synonym: boolean;
}
