import 'package:flutter/material.dart';
import '../../constants/constant.dart';

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
      color: MyColors.toolButtonBackground,

      child: ToggleButtons(
        // デザイン
        borderWidth: MyDimens.toolButtonBorderWidth,
        borderColor: MyColors.toolButtonBorder,
        selectedBorderColor: MyColors.toolButtonBorder,
        borderRadius: BorderRadius.circular(MyDimens.toolButtonBorderRadius),
        constraints: const BoxConstraints(
          minWidth: MyDimens.toolButtonWidth - MyDimens.toolButtonBorderWidth * 2,
          minHeight: MyDimens.toolButtonHeight - MyDimens.toolButtonBorderWidth * 2,
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
                width: MyDimens.toolButtonWidth - MyDimens.toolButtonBorderWidth * 2,
                height: MyDimens.toolButtonHeight - MyDimens.toolButtonBorderWidth * 2,
                child: icons[i],
              ),
            ),
          },
        ],
      ),
    );
  }
}