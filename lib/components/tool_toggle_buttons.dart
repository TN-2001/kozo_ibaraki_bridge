import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/constants/app_colors.dart';


class ToolToggleButtons extends StatefulWidget {
  const ToolToggleButtons({super.key, required this.icons, required this.onPressed});

  final List<IconData> icons;
  final void Function(int index) onPressed;

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
      color: AppColors.toolBaseColor,

      child: ToggleButtons(
        // デザイン
        borderColor: AppColors.toolBorderColor,
        selectedBorderColor: AppColors.toolBorderColor,
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
            Icon(widget.icons[i]),
          },
        ],
      ),
    );
  }
}