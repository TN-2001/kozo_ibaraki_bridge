import 'package:flutter/material.dart';
import '../../../components/tool_ui/tool_bar_divider.dart';
import '../../../components/tool_ui/tool_dropdown_button.dart';
import '../../../components/tool_ui/tool_icon_button.dart';
import '../../../components/tool_ui/tool_toggle_buttons.dart';
import '../../../constants/colors.dart';
import '../../../constants/dimens.dart';
import '../../../constants/paths.dart';
import '../models/bridgegame_controller.dart';

class BridgegameUI extends StatefulWidget {
  const BridgegameUI({super.key, required this.controller});

  final BridgegameController controller;

  @override
  State<BridgegameUI> createState() => _BridgegameUIState();
}

class _BridgegameUIState extends State<BridgegameUI> {

  int state = 0;
  int _toolIndex = 0;
  int _powerIndex = 0;


  void _onPressedMenuButton() {

  }

  void _onPressedToolToggle(int index) {
    setState(() {
      _toolIndex = index;
    });
    widget.controller.changeToolIndex(_toolIndex);
  }

  void _onPressedUndoButton() {
    widget.controller.undo();
  }

  void _onPressedRedoButton() {
    widget.controller.redo();
  }

  void _onPressedMirrorButton() {
    widget.controller.symmetrical();
  }

  void _onPressedClearButton() {
    widget.controller.clear();
  }

  void _onPressedPowerDropdown(int indent) {
    setState(() {
      _powerIndex = indent;
    });
    widget.controller.changePowerIndex(_powerIndex);
  }

  Future<void> _onPressedAnalysisButton() async{    
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54, // 背景を暗く
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // インジケーターを白く
            ),
            SizedBox(height: 20), // インジケーターとテキストの間にスペースを追加
            Text("解析中", 
              style: TextStyle(
                color: Colors.white, // テキストを白く
                fontSize: 20,
              ),
            ),
          ]
        );
      },
    );

    // 3秒間の処理時間をシミュレート
    await widget.controller.calculation();

    // ダイアログを閉じる
    if (!mounted) return;
    Navigator.of(context).pop();
    
    if (widget.controller.isCalculation) {
      setState(() {
        state = 1;
      });
    }

    // 完了メッセージを表示
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('処理が完了しました')),
    );
  }

  void _onPressedEditButton() {
    setState(() {
      state = 0;
    });
    widget.controller.resetCalculation();
  }


  Widget _menuButton() {
    return ToolIconButton(
      onPressed: _onPressedMenuButton, 
      icon: Icon(Icons.menu),
      message: "メニュー",
    );
  }


  @override
  void initState() {
    super.initState();
    _onPressedToolToggle(0);
  }

  @override
  Widget build(BuildContext context) {
    if (state == 0) {
      return Container(
        width: double.infinity,
        height: ToolBarDimens.height,
        color: BaseColors.baseColor,
        child: Row(
          children: [
            SizedBox(width: ToolUIDimens.gapWidth,),

            _menuButton(),

            SizedBox(width: ToolUIDimens.gapWidth,),
            ToolBarDivider(isVertivcal: true,),
            SizedBox(width: ToolUIDimens.gapWidth,),

            ToolToggleButtons(
              selectedIndex: _toolIndex,
              onPressed: _onPressedToolToggle,
              icons: [
                Icon(Icons.brush),
                ImageIcon(AssetImage(ImagePass.iconEraser)),
              ],
              messages: ["筆", "消しゴム"],
            ),

            SizedBox(width: ToolUIDimens.gapWidth,),
            ToolBarDivider(isVertivcal: true,),
            SizedBox(width: ToolUIDimens.gapWidth,),

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

            SizedBox(width: ToolUIDimens.gapWidth,),
            ToolBarDivider(isVertivcal: true,),
            Expanded(child: SizedBox()),
            ToolBarDivider(isVertivcal: true,),
            SizedBox(width: ToolUIDimens.gapWidth,),

            ToolDropdownButton(
              selectedIndex: _powerIndex,
              onPressed: _onPressedPowerDropdown,
              items: ["3点曲げ", "4点曲げ", "自重"], 
            ),

            SizedBox(width: ToolUIDimens.gapWidth,),
            ToolBarDivider(isVertivcal: true,),
            SizedBox(width: ToolUIDimens.gapWidth,),

            ToolIconButton(
              onPressed: _onPressedAnalysisButton,
              icon: Icon(Icons.play_arrow),
              message: "解析",
            ),

            SizedBox(width: ToolUIDimens.gapWidth,),
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
            SizedBox(width: ToolUIDimens.gapWidth,),

            _menuButton(),

            SizedBox(width: ToolUIDimens.gapWidth,),
            ToolBarDivider(isVertivcal: true,),
            Expanded(child: SizedBox()),
            ToolBarDivider(isVertivcal: true,),
            SizedBox(width: ToolUIDimens.gapWidth,),

            ToolIconButton(
              onPressed: _onPressedEditButton,
              icon: Icon(Icons.restart_alt),
              message: "再編集",
            ),

            SizedBox(width: ToolUIDimens.gapWidth,),
          ],
        ),
      );
    }
  }
}