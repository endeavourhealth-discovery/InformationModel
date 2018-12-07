import {DbEntity} from 'im-common/dist/models/DbEntity';

export class ViewItem extends DbEntity {
  conceptId: number;
  conceptName: string;
  parentId: number;
  contextId: number;
  contextName: string;

  loading: boolean = false;
  hasChildren: boolean = true;
  isExpanded: boolean = false;
  children: ViewItem[];
}
