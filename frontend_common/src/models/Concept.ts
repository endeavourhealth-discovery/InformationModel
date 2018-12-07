import {Reference} from './Reference';
import {ConceptStatus} from './ConceptStatus';
import {DbEntity} from './DbEntity';

export class Concept extends DbEntity {
  superclass: Reference;
  url: string;
  fullName: string;
  shortName: string;
  context: string;
  status: ConceptStatus;
  version: number;
  description: string;
  useCount: number;
  scheme: Reference;
}
