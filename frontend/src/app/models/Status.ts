export enum Status {
  DRAFT = 0,
  INCOMPLETE = 1,
  ACTIVE = 2,
  DEPRECATED = 3
}

export class StatusHelper {
  public static getName(status: Status): string {
    switch (status) {
      case Status.DRAFT: return 'Draft';
      case Status.INCOMPLETE: return 'Incomplete';
      case Status.ACTIVE: return 'Active';
      case Status.DEPRECATED: return 'Deprecated';
      default: return 'Unknown ['+status+']';
    }
  }
}
