import 'package:flutter/material.dart';

import '../../../components/tool_ui/tool_bar_divider.dart';
import '../../../components/tool_ui/tool_icon_button.dart';
import '../../../components/tool_ui/tool_toggle_buttons.dart';
import '../../../constants/dimens.dart';
import '../../../constants/paths.dart';
import '../models/bridgegame_controller.dart';

class BridgegameToolBar extends StatefulWidget {
  const BridgegameToolBar({super.key, required this.controller});

  final BridgegameController controller;

  @override
  State<BridgegameToolBar> createState() => _BridgegameToolBarState();
}

class _BridgegameToolBarState extends State<BridgegameToolBar> {
  late BridgegameController _controller;
  int _toolIndex = 0;


  void _onPressedToolToggle(int index) {
    setState(() {
      _toolIndex = index;
    });
    _controller.changeToolIndex(_toolIndex);
  }

  // void _onPressedUndoButton() {
  //   _controller.undo();
  // }

  // void _onPressedRedoButton() {
  //   _controller.redo();
  // }

  void _onPressedMirrorButton() {
    _controller.symmetrical();
  }

  void _onPressedClearButton() {
    _controller.clear();
  }


  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _onPressedToolToggle(_controller.toolIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: ToolUIDimens.gapWidth,),

        ToolToggleButtons(
          selectedIndex: _toolIndex,
          onPressed: _onPressedToolToggle,
          icons: [
            const Icon(Icons.brush),
            ImageIcon(AssetImage(ImagePass.iconEraser)),
          ],
          messages: const ["ペン", "消しゴム"],
        ),

        SizedBox(width: ToolUIDimens.gapWidth,),
        const ToolBarDivider(isVertivcal: true,),
        SizedBox(width: ToolUIDimens.gapWidth,),

        // ToolIconButton(
        //   onPressed: _onPressedUndoButton,
        //   icon: const Icon(Icons.undo), 
        //   message: "戻る", 
        // ),
        // ToolIconButton(
        //   onPressed: _onPressedRedoButton,
        //   icon: const Icon(Icons.redo), 
        //   message: "進む", 
        // ),
        ToolIconButton(
          onPressed: _onPressedMirrorButton, 
          icon: const Icon(Icons.switch_right),
          message: "対称化（左を右にコピー）",
        ),
        ToolIconButton(
          onPressed: _onPressedClearButton,
          icon: const Icon(Icons.clear), 
          message: "クリア", 
        ),

        SizedBox(width: ToolUIDimens.gapWidth,),
      ]
    );
  }
}