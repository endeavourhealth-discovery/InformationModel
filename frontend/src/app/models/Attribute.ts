import {Reference} from './Reference';
import {DbEntity} from './DbEntity';
// import {AttributeValue} from './AttributeValue';

export class Attribute extends DbEntity {
  public concept: Reference;
  public attribute: Reference;
  public type: Reference;
  // public value: AttributeValue;
  public minimum: number;
  public maximum: number;
  public isConstraint: boolean;
  public valueConcept: Reference;
  public valueExpression: number;
  public fixedConcept: Reference;
  public fixedValue: string;

}
