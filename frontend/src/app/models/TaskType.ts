export enum TaskType {
  ATTRIBUTE_MODEL = 0,
  VALUE_MODEL = 1,
  MESSAGE_MAPPINGS = 2,
  TERM_MAPPINGS = 3,
}

export class TaskTypeHelper {
  public static getName(taskType: TaskType): string {
    switch (taskType) {
      case TaskType.ATTRIBUTE_MODEL: return 'Attribute model';
      case TaskType.VALUE_MODEL: return 'Value model';
      case TaskType.MESSAGE_MAPPINGS: return 'Message Mappings';
      case TaskType.TERM_MAPPINGS: return 'Term Mappings';
      default: return 'Unknown';
    }
  }
}
