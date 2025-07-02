import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/constants/colors.dart';
import 'package:kozo_ibaraki_bridge/constants/dimens.dart';

class ToolDropdownButton extends StatefulWidget {
  const ToolDropdownButton({super.key, required this.items, required this.onPressed});

  final List<String> items;
  final void Function(int index) onPressed;

  @override
  State<ToolDropdownButton> createState() => _ToolDropdownButtonState();
}

class _ToolDropdownButtonState extends State<ToolDropdownButton> {
  late String _currentItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // デザイン
      // width: ToolUIDimens.width * 2,
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
        value: _currentItem,
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        // イベント
        onChanged: (value) {
          for (int i = 0; i < widget.items.length; i++) {
            if (value == widget.items[i]) {
              setState(() {
                _currentItem = widget.items[i];
              });
              widget.onPressed(i);
              break;
            }
          }
        },
      ),
    );
  }
}