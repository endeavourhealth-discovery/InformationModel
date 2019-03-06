import {Status} from './Status';

export class Concept {
  dbid: number;
  id: string;
  name: string;
  scheme: string;
  code: string;
  status: Status;
  updated: Date;
}
