import 'package:flutter/material.dart';
import '/constants/colors.dart';
import '/constants/dimens.dart';


class ToolToggleButtons extends StatelessWidget {
  const ToolToggleButtons({
    super.key, 
    required this.selectedIndex,
    required this.onPressed,
    required this.icons, 
    this.messages = const [], 
  });

  final int selectedIndex;
  final void Function(int index) onPressed;
  final List<Widget> icons;
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    // トグルのOn・Off設定。一つのみOn
    final List<bool> selected = List.filled(icons.length, false);
    selected[selectedIndex] = true;

    return Container(
      // デザイン
      color: ToolUIColors.baseColor,

      child: ToggleButtons(
        // デザイン
        borderWidth: ToolUIDimens.borderWidth,
        borderColor: ToolUIColors.borderColor,
        selectedBorderColor: ToolUIColors.borderColor,
        borderRadius: BorderRadius.zero,
        constraints: BoxConstraints(
          minWidth: ToolUIDimens.width - ToolUIDimens.borderWidth*2,
          minHeight: ToolUIDimens.height - ToolUIDimens.borderWidth*2,
        ),
        // イベント
        onPressed: onPressed,
        // ウィジェット
        isSelected: selected,
        children: [
          for (int i = 0; i < icons.length; i++)...{
            Tooltip(
              message: messages.length > i ? messages[i] : "",
              child: SizedBox(
                width: ToolUIDimens.width - ToolUIDimens.borderWidth*2,
                height: ToolUIDimens.height - ToolUIDimens.borderWidth*2,
                child: icons[i],
              ),
            ),
          },
        ],
      ),
    );
  }
}