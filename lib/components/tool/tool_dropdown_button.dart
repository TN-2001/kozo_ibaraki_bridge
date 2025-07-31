import 'package:flutter/material.dart';
import '../../constants/constant.dart';

class ToolDropdownButton extends StatelessWidget {
  const ToolDropdownButton({
    super.key, 
    required this.selectedIndex, 
    required this.onPressed,
    required this.items, 
  });

  final int selectedIndex;
  final void Function(int index) onPressed;
  final List<String> items;


  @override
  Widget build(BuildContext context) {
    return Container(
      // デザイン
      height: MyDimens.toolButtonHeight,
      decoration: BoxDecoration(
        color: MyColors.toolBarBackground,
        border: Border.all(
          color: MyColors.toolButtonBorder,
          width: MyDimens.toolButtonBorderWidth,
        ),
      ),

      child: DropdownButton(
        // ボタンのデザイン
        underline: const SizedBox(),
        // ドロップダウンのデザイン
        dropdownColor: MyColors.toolDropdownBackground,
        borderRadius: BorderRadius.circular(MyDimens.toolDropdownBorderRadius),
        elevation: MyDimens.toolDropdownElevation.toInt(),
        
        // アイテムのデザイン
        itemHeight: MyDimens.toolDropdownItemHeight,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        // イベント
        value: items[selectedIndex],
        onChanged: (value) {
          for (int i = 0; i < items.length; i++) {
            if (value == items[i]) {
              onPressed(i);
              break;
            }
          }
        },
      ),
    );
  }
}