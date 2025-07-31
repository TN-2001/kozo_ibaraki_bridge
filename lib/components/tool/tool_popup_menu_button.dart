import 'package:flutter/material.dart';
import '../../constants/constant.dart';

class ToolPopupMenuButton extends StatelessWidget {
  const ToolPopupMenuButton({super.key, required this.texts, required this.onSelected});

  final List<String> texts;
  final void Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // デザイン
      width: MyDimens.toolButtonWidth,
      height: MyDimens.toolButtonHeight,
      color: MyColors.toolButtonBackground,

      child: PopupMenuButton<String>(
        // ボタンのデザイン
        icon: const Icon(Icons.menu),
        tooltip: "メニュー",
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MyDimens.toolButtonBorderRadius),
              side: const BorderSide(
                color: MyColors.toolButtonBorder, // ここで色を指定
                width: MyDimens.toolButtonBorderWidth, // 線の太さも指定可能
              ),
            ),
          ),
        ),
        // ドロップダウンのデザイン
        color: MyColors.toolDropdownBackground,
        elevation: MyDimens.toolDropdownElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyDimens.toolDropdownBorderRadius),
          side: const BorderSide(
            color: MyColors.toolDropdownBackground, // ここで色を指定
            width: MyDimens.toolDropdownBorderWidth, // 線の太さも指定可能
          ),
        ),
        menuPadding: EdgeInsets.zero,
        position: PopupMenuPosition.under,
        // アイテムのデザイン
        padding: const EdgeInsets.all(0),
        itemBuilder: (BuildContext context) {
          return [
            for (int i = 0; i < texts.length; i++)...{
              PopupMenuItem(
                height: MyDimens.toolDropdownItemHeight,
                value: texts[i],
                child: Text(
                  texts[i],
                  style: const TextStyle(fontSize: MyDimens.toolDropdownItemFontSize),
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