import {Reference} from './Reference';
import {ConceptStatus} from './ConceptStatus';
import {DbEntity} from './DbEntity';

export class Concept extends DbEntity {
  superclass: Reference = {id: 1, name: 'Concept'};
  url: string;
  fullName: string;
  shortName: string;
  context: string;
  status: ConceptStatus = ConceptStatus.DRAFT;
  version: number = 0.1;
  description: string;
  useCount: number;
  scheme: Reference = {id: 5307, name: 'Discovery'};
}
