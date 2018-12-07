import {DbEntity} from 'im-common/dist/models/DbEntity';
import {Reference} from 'im-common/dist/models/Reference';
import {ConceptStatus} from 'im-common/dist/models/ConceptStatus';

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
