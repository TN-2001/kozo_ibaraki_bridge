import 'package:flutter/material.dart';
import '../../../components/component.dart';
import '../../../constants/constant.dart';
import '../models/bridgegame_controller.dart';

class BridgegameBar extends StatefulWidget {
  const BridgegameBar({super.key, required this.controller, required this.scaffoldKey});

  final BridgegameController controller;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<BridgegameBar> createState() => _BridgegameBarState();
}

class _BridgegameBarState extends State<BridgegameBar> {
  late BridgegameController _controller;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  int state = 0;
  int _toolIndex = 0;
  int _powerIndex = 0;


  void _onPressedMenuButton() {
    // _scaffoldKey.currentState?.openDrawer();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          backgroundColor: MyColors.baseBackground,

          child: Column(
            children: [
              ToolBar(
                children: [
                  ToolIconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(Icons.keyboard_arrow_left_sharp),
                    message: "戻る",
                  ),
                ]
              ),

              const BaseDivider(),

              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Image.asset("assets/images/help/help_01.png"),
                          const SizedBox(height: 10),
                          Image.asset("assets/images/help/help_02.png"),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
        return const Column(
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
    // if (!mounted) return;
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('処理が完了しました')),
    // );
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
      icon: const Icon(Icons.menu),
      message: "メニュー",
    );
  }


  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _scaffoldKey = widget.scaffoldKey;

    _onPressedToolToggle(_controller.toolIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (state == 0) {
      return ToolBar(
        children: [
          _menuButton(),

          const ToolBarDivider(isVertivcal: true,),

          // BridgegameToolBar(controller: widget.controller),

          ToolToggleButtons(
            selectedIndex: _toolIndex,
            onPressed: _onPressedToolToggle,
            icons: [
              const Icon(Icons.brush),
              ImageIcon(AssetImage(ImagePass.iconEraser)),
            ],
            messages: const ["ペン", "消しゴム"],
          ),

          const ToolBarDivider(isVertivcal: true,),

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

          const ToolBarDivider(isVertivcal: true,),
          const Expanded(child: SizedBox()),
          const ToolBarDivider(isVertivcal: true,),

          ToolDropdownButton(
            selectedIndex: _powerIndex,
            onPressed: _onPressedPowerDropdown,
            items: const ["荷重1", "荷重2", "自重"], 
          ),

          const ToolBarDivider(isVertivcal: true,),

          ToolIconButton(
            onPressed: _onPressedAnalysisButton,
            icon: const Icon(Icons.play_arrow),
            message: "解析",
          ),
        ],
      );
    }
    else {
      return ToolBar(
        children: [
          _menuButton(),

          const ToolBarDivider(isVertivcal: true,),
          const Expanded(child: SizedBox()),
          const ToolBarDivider(isVertivcal: true,),

          ToolIconButton(
            onPressed: _onPressedEditButton,
            icon: const Icon(Icons.restart_alt),
            message: "再編集",
          ),
        ],
      );
    }
  }
}