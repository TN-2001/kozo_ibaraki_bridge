/*
  寸法を定義する。
  Define dimensions here.
*/

class MyDimens {
  static const double baseDividerWidth = 1.0; // 線の幅
  static const double baseFontSize = 14.0; // 文字の大きさ

  static const double toolBarWidth = 52.0;
  static const double toolBarHeight = 52.0;
  static const double toolBarGapWidth = 4.0;
  static const double toolBarDividerWidth = 1.0;
  static const double toolBarDividerIndent = 1.0;

  static const double toolButtonWidth = toolBarWidth - toolBarGapWidth * 2;
  static const double toolButtonHeight = toolBarHeight - toolBarGapWidth * 2;
  static const double toolButtonBorderWidth = 0.0;
  static const double toolButtonBorderRadius = 0.0; // ボタンの角の丸み

  static const double toolDropdownElevation = 8.0; // 影の大きさ
  static const double toolDropdownBorderWidth = 0.0;
  static const double toolDropdownBorderRadius = 8.0; // ウィンドウの角の丸み
  static const double toolDropdownItemHeight = 48.0; // テキストボタンの高さ
  static const double toolDropdownItemFontSize = 14.0;
}