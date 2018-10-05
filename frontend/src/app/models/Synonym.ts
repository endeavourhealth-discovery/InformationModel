import {DbEntity} from './DbEntity';
import {ConceptStatus} from './ConceptStatus';

export class Synonym extends DbEntity {
  concept: number;
  term: string;
  preferred: boolean;
  status: ConceptStatus;
}
