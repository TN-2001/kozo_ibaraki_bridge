/*
  寸法を定義する。
  Define dimensions here.
*/

/*
  ベースの寸法
  Base dimensions
*/
class Dimens {
  static const double textButtonHeight = 40.0; // テキストボタンの高さ

  static const double dividerWidth = 1.0; // 線の幅

  static const double elevation = 5.0; // 影の大きさ

  static const double fontSize = 14.0; // 文字の大きさ

  static const double windowBorderRadius = 0.0; // ウィンドウの角の丸み
  static const double buttonBorderRadius = 0.0; // ボタンの角の丸み
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