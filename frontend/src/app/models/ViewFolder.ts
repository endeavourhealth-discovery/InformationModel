export class ViewFolder {
  id: number;
  name: string;
  description: string;
  loading: boolean;
  hasChildren: boolean;
  isExpanded: boolean;
  children: ViewFolder[];
}
