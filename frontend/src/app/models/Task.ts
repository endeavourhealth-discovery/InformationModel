import {TaskType} from './TaskType';
import {DbEntity} from 'im-common/dist/models/DbEntity';

export class Task extends DbEntity {
  public type: TaskType;
  public name: string;
  public description: string;
  public created: Date;
  public identifier: number;
}
