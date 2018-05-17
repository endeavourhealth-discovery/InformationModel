import {DbEntity} from './DbEntity';
import {TaskType} from './TaskType';

export class Task extends DbEntity {
  public type: TaskType;
  public name: string;
  public created: Date;
  public identifier: number;
}
