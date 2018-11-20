export enum ValueExpression {
  OF_CLASS = 0,
  CHILD_OF = 1,
  CLASS_OR_CHILD = 2
}

export class ValueExpressionHelper {
  public static getPrefix(valueExpression: ValueExpression): string {
    switch (valueExpression) {
      case ValueExpression.OF_CLASS: return 'A';
      case ValueExpression.CHILD_OF: return 'A child of';
      case ValueExpression.CLASS_OR_CHILD: return 'A type, or sub type of';
      default: return 'Unknown ['+valueExpression+']';
    }
  }

  public static getOptions(): any[] {
    return Object
      .keys(ValueExpression)
      .filter(key => typeof ValueExpression[key] === 'number')
      .map(k => ValueExpression[k]);
  }
}
