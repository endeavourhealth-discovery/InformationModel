export enum ValueExpression {
  OF_CLASS = 0,
  CHILD_OF = 1,
  CLASS_OR_CHILD = 2
}

export class ValueExpressionHelper {
  public static getPrefix(valueExpression: ValueExpression): string {
    switch (valueExpression) {
      case ValueExpression.OF_CLASS: return 'A';
      case ValueExpression.CHILD_OF: return 'Sub type of';
      default: return '';
    }
  }
  public static getSuffix(valueExpression: ValueExpression): string {
    switch (valueExpression) {
      case ValueExpression.CLASS_OR_CHILD: return '(or sub type)';
      default: return '';
    }
  }
}
