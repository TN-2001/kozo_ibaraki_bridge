import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/components/tool_ui/tool_bar_divider.dart';
import 'package:kozo_ibaraki_bridge/components/tool_ui/tool_dropdown_button.dart';
import 'package:kozo_ibaraki_bridge/components/tool_ui/tool_icon_button.dart';
import 'package:kozo_ibaraki_bridge/components/tool_ui/tool_toggle_buttons.dart';
import 'package:kozo_ibaraki_bridge/constants/colors.dart';
import 'package:kozo_ibaraki_bridge/constants/paths.dart';

class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {

  int state = 0;
  int _toolIndex = 0;
  int _powerIndex = 0;
  

  void _onPressedMenuButton() {

  }

  void _onPressedToolToggle(int index) {
    setState(() {
      _toolIndex = index;
    });
  }

  void _onPressedUndoButton() {

  }

  void _onPressedRedoButton() {

  }

  void _onPressedMirrorButton() {

  }

  void _onPressedClearButton() {

  }

  void _onPressedPowerDropdown(int indent) {
    setState(() {
      _powerIndex = indent;
    });
  }

  void _onPressedAnalysisButton() {

  }

  void _onPressedEditButton() {

  }


  Widget _menuButton() {
    return ToolIconButton(
      onPressed: _onPressedMenuButton, 
      icon: Icon(Icons.menu),
      message: "メニュー",
    );
  }


  @override
  Widget build(BuildContext context) {
    if (state == 0) {
      return Container(
        width: double.infinity,
        color: BaseColors.baseColor,
        child: Row(
          children: [
            _menuButton(),

            ToolBarDivider(isVertivcal: true,),

            ToolToggleButtons(
              selectedIndex: _toolIndex,
              onPressed: _onPressedToolToggle,
              icons: [
                Icon(Icons.brush),
                ImageIcon(AssetImage(ImagePass.iconEraser)),
              ],
              messages: ["筆", "消しゴム"],
            ),

            ToolBarDivider(isVertivcal: true,),

            ToolIconButton(
              onPressed: _onPressedUndoButton,
              icon: Icon(Icons.undo), 
              message: "戻る", 
            ),
            ToolIconButton(
              onPressed: _onPressedRedoButton,
              icon: Icon(Icons.redo), 
              message: "進む", 
            ),
            ToolIconButton(
              onPressed: _onPressedMirrorButton, 
              icon: Icon(Icons.switch_right),
              message: "対称化（左を右にコピー）",
            ),
            ToolIconButton(
              onPressed: _onPressedClearButton,
              icon: Icon(Icons.clear), 
              message: "クリア", 
            ),

            ToolBarDivider(isVertivcal: true,),
            Expanded(child: SizedBox()),
            ToolBarDivider(isVertivcal: true,),

            ToolDropdownButton(
              selectedIndex: _powerIndex,
              onPressed: _onPressedPowerDropdown,
              items: ["3点曲げ", "4点曲げ", "自重"], 
            ),

            ToolBarDivider(isVertivcal: true,),

            ToolIconButton(
              onPressed: _onPressedAnalysisButton,
              icon: Icon(Icons.play_arrow),
              message: "解析",
            ),
          ],
        ),
      );
    }
    else {
      return Container(
        width: double.infinity,
        color: BaseColors.baseColor,
        child: Row(
          children: [
            _menuButton(),

            ToolBarDivider(isVertivcal: true,),
            Expanded(child: SizedBox()),
            ToolBarDivider(isVertivcal: true,),

            ToolIconButton(
              onPressed: _onPressedEditButton,
              icon: Icon(Icons.restart_alt),
              message: "再編集",
            ),
          ],
        ),
      );
    }
  }
}