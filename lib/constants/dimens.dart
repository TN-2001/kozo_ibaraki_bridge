/*
  寸法を定義する。
  Define dimensions here.
*/

/*
  ベースの寸法
  Base dimensions
*/
class BaseDimens {
  static double dividerWidth = 1.0;
}

/*
  UIの寸法
  UI dimensions
*/
class UIDimens {
  static double padding = 10.0;
}

/*
  ツールバーの寸法
  Tool bar dimensions
*/
class ToolBarDimens {
  static double width = ToolUIDimens.width + ToolUIDimens.gapWidth * 2;
  static double height = ToolUIDimens.height + ToolUIDimens.gapWidth * 2;
  static double dividerWidth = 1.0;
  static double dividerIndent = 1.0;
}

/*
  ツールUIの寸法
  Tool UI dimensions
*/
class ToolUIDimens {
  static double width = 40.0;
  static double height = 40.0;
  static double borderWidth = 0.0;

  static double gapWidth = 5.0;
}