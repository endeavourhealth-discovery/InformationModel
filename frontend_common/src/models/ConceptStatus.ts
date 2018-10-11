export enum ConceptStatus {
  DRAFT = 0,
  ACTIVE = 1,
  DEPRECATED = 2,
  TEMPORARY = 3
}

export class ConceptStatusHelper {
  public static getName(conceptStatus: ConceptStatus): string {
    switch (conceptStatus) {
      case ConceptStatus.DRAFT: return 'Draft';
      case ConceptStatus.ACTIVE: return 'Active';
      case ConceptStatus.DEPRECATED: return 'Deprecated';
      case ConceptStatus.TEMPORARY: return 'Temporary';
      default: return 'Unknown';
    }
  }
}
