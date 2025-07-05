import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/constants/dimens.dart';

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
      height: ToolUIDimens.height,
      decoration: BoxDecoration(
        color: ToolUIColors.baseColor,
        border: Border.all(
          color: ToolUIColors.borderColor,
          width: ToolUIDimens.borderWidth,
        ),
      ),

      child: DropdownButton(
        // デザイン
        underline: SizedBox(),
        // 表示
        value: items[selectedIndex],
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        // イベント
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