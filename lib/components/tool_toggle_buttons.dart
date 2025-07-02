import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/constants/colors.dart';
import 'package:kozo_ibaraki_bridge/constants/dimens.dart';


class ToolToggleButtons extends StatefulWidget {
  const ToolToggleButtons({
    super.key, 
    required this.icons, 
    required this.onPressed,
    this.messages = const [],
  });

  final List<IconData> icons;
  final void Function(int index) onPressed;
  final List<String> messages;

  @override
  State<ToolToggleButtons> createState() => _ToolToggleButtonsState();
}

class _ToolToggleButtonsState extends State<ToolToggleButtons> {
  int _selectedIndex = 0; // Onのトグル番号

  @override
  Widget build(BuildContext context) {
    // トグルのOn・Off設定。一つのみOn
    final List<bool> selected = List.filled(widget.icons.length, false);
    selected[_selectedIndex] = true;

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
          minWidth: ToolUIDimens.width - ToolUIDimens.borderWidth-2,
          minHeight: ToolUIDimens.height - ToolUIDimens.borderWidth-2,
        ),
        // イベント
        onPressed: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          widget.onPressed(index);
        },
        // ウィジェット
        isSelected: selected,
        children: [
          for (int i = 0; i < widget.icons.length; i++)...{
            Tooltip(
              message: widget.messages.length > i ? widget.messages[i] : "",
              child: Icon(
                widget.icons[i]
              ),
            ),
          },
        ],
      ),
    );
  }
}