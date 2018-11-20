import {Reference} from './Reference';
import {DbEntity} from './DbEntity';
import {ConceptStatus} from './ConceptStatus';
// import {AttributeValue} from './AttributeValue';

export class Attribute extends DbEntity {
  public concept: Reference;
  public attribute: Reference;
  public type: Reference;
  public order: number;
  public mandatory: boolean;
  public limit: number;
  public inheritance: number;
  public valueConcept: Reference;
  public valueExpression: number;
  public fixedConcept: Reference;
  public fixedValue: string;
  public status: ConceptStatus;

}
