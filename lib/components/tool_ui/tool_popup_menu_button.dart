import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/dimens.dart';

class ToolPopupMenuButton extends StatelessWidget {
  const ToolPopupMenuButton({super.key, required this.texts, required this.onSelected});

  final List<String> texts;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // デザイン
      width: ToolUIDimens.width,
      height: ToolUIDimens.height,
      color: ToolUIColors.baseColor,

      child: PopupMenuButton<String>(
        // ボタンのデザイン
        icon: Icon(Icons.menu),
        tooltip: "メニュー",
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.buttonBorderRadius),
              side: BorderSide(
                color: ToolUIColors.borderColor, // ここで色を指定
                width: ToolUIDimens.borderWidth, // 線の太さも指定可能
              ),
            ),
          ),
        ),
        // メニューのデザイン
        color: ToolUIColors.baseColor,
        elevation: Dimens.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.windowBorderRadius),
          side: BorderSide(
            color: ToolUIColors.borderColor, // ここで色を指定
            width: ToolUIDimens.borderWidth, // 線の太さも指定可能
          ),
        ),
        menuPadding: EdgeInsets.zero,
        position: PopupMenuPosition.under,
        // アイテムのデザイン
        padding: EdgeInsets.all(0),
        itemBuilder: (BuildContext context) {
          return [
            for (int i = 0; i < texts.length; i++)...{
              PopupMenuItem(
                height: Dimens.textButtonHeight,
                value: texts[i],
                child: Text(
                  texts[i],
                  style: TextStyle(fontSize: Dimens.fontSize),
                ),
              ),
            },
          ];
        },
        // イベント
        onSelected: (String value) {
          for (int i = 0; i < texts.length; i++) {
            if (value == texts[i]) {
              onSelected(i);
            }
          }
        },
      ),
    );
  }
}