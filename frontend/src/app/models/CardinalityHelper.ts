export class CardinalityHelper {
  public static asNumeric(mandatory: boolean, limit: number): string {
    if (mandatory) {
      if (limit == 0) return '1:*';
      return '1:' + limit.toString();
    } else {
      if (limit == 0) return '0:*';
      return '0:' + limit.toString();
    }
  }
  public static asEnglish(mandatory: boolean, limit: number): string {
    if (mandatory) {
      if (limit == 0) return 'at least one';
      if (limit == 1) return 'one';
      return 'between 1 and ' + limit.toString();
    } else {
      if (limit == 0) return 'zero or more';
      if (limit == 1) return 'an optional';
      return 'zero to ' + limit.toString();
    }
  }
}
