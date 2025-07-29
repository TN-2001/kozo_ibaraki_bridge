import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/component.dart';
import 'canvas/bridgegame_canvas.dart';
import 'models/bridgegame_controller.dart';
import 'ui/bridgegame_ui.dart';

class BridgegamePage extends StatefulWidget {
  const BridgegamePage({super.key});

  @override
  State<BridgegamePage> createState() => _BridgegamePageState();
}

class _BridgegamePageState extends State<BridgegamePage> {
  late BridgegameController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Orientation? _lastOrientation;

  void _update() => setState(() {});


  @override
  void initState() {
    super.initState();
    controller = BridgegameController();
    controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    // 向きが変わった時だけ処理を行う
    if (_lastOrientation != orientation) {
      _lastOrientation = orientation;

      if (orientation == Orientation.landscape) {
        // 横向きならステータスバーを非表示
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        // 縦向きならステータスバーを表示
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: SafeArea(
        child: ClipRect(
          child: Column(
            children: [
              BridgegameUI(controller: controller, scaffoldKey: _scaffoldKey,),

              const BaseDivider(),

              Expanded(
                child: Stack(
                  children: [
                    BridgegameCanvas(controller: controller,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}