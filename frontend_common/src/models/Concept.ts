import {Reference} from './Reference';
import {ConceptStatus} from './ConceptStatus';
import {DbEntity} from './DbEntity';

export class Concept extends DbEntity {
  public superclass: Reference;
  public url: string;
  public fullName: string;
  public shortName: string;
  public context: string;
  public status: ConceptStatus;
  public version: number;
  public description: string;
  public useCount: number;
}
