import {DbEntity} from 'im-common/dist/models/DbEntity';
import {ConceptStatus} from 'im-common/dist/models/ConceptStatus';

export class Synonym extends DbEntity {
  concept: number;
  term: string;
  preferred: boolean;
  status: ConceptStatus;
}
