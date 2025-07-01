import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/components/tool_icon_button.dart';
import 'package:kozo_ibaraki_bridge/components/tool_toggle_buttons.dart';
import 'package:kozo_ibaraki_bridge/views/main/ui/main_ui_layout.dart';
import 'package:kozo_ibaraki_bridge/views/main/ui/main_ui_powerDropdown.dart';

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
          ),
          ToolIconButton(
            onPressed: (){}, 
            icon: Icons.switch_right,
          ),
          MainUIPowerdropdown(
            onPressed: (int index) {
              powerNum = index;
            } 
          ),
        ],
        rightHeader: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.play_arrow)
          ),
        ],
      );
    }
    else if (state == 1) {
      return MainUILayout(
        rightHeader: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.restart_alt)
          ),
        ],
      );
    }
    else {
      return SizedBox();
    }
  }
}