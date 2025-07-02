import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/components/tool_dropdown_button.dart';
import 'package:kozo_ibaraki_bridge/components/tool_icon_button.dart';
import 'package:kozo_ibaraki_bridge/components/tool_toggle_buttons.dart';
import 'package:kozo_ibaraki_bridge/views/main/ui/main_ui_layout.dart';

class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  State<MainUI> createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {

  int powerNum = 0;
  int state = 0;
  

  @override
  Widget build(BuildContext context) {
    if (state == 0) {
      return MainUILayout(
        leftHeader: [
          ToolToggleButtons(
            onPressed: (int index) {
              // handle toggle button press
            },
            icons: [
              Icons.edit,
              Icons.auto_fix_normal,
            ],
            messages: ["ペン", "消しゴム"],
          ),
          ToolIconButton(
            onPressed: (){}, 
            icon: Icons.switch_right,
            message: "対称化（左を右にコピー）",
          ),
          ToolIconButton(
            onPressed: (){}, 
            icon: Icons.restart_alt,
            message: "リセット",
          ),
          ToolDropdownButton(
            onPressed: (int index) {
              powerNum = index;
            }, 
            items: ["3点曲げ", "4点曲げ", "自重"], 
          ),
        ],
        rightHeader: [
          ToolIconButton(
            onPressed: (){}, 
            icon: Icons.play_arrow,
            message: "解析",
          ),
        ],
      );
    }
    else if (state == 1) {
      return MainUILayout(
        rightHeader: [
          ToolIconButton(
            onPressed: (){}, 
            icon: Icons.restart_alt,
            message: "再編集",
          ),
        ],
      );
    }
    else {
      return SizedBox();
    }
  }
}