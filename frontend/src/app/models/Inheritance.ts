export enum Inheritance {
  UNCHANGED = 0,
  EXTENDS = 1,
  CONSTRAINS = 2
}

export class InheritanceHelper {
  public static getName(inheritance: Inheritance): string {
    switch (inheritance) {
      case Inheritance.UNCHANGED: return '';
      case Inheritance.EXTENDS: return 'Extends';
      case Inheritance.CONSTRAINS: return 'Constrains';
      default: return 'Unknown';
    }
  }

  public static getIcon(inheritance: Inheritance): string {
    switch (inheritance) {
      case Inheritance.UNCHANGED: return 'text-info fa fa-fw fa-circle';
      case Inheritance.EXTENDS: return 'text-success fa fa-fw fa-plus-circle';
      case Inheritance.CONSTRAINS: return 'text-warning fa fa-fw fa-minus-circle';
      default: return 'fa fa-fw fa-blank';
    }
  }
}
