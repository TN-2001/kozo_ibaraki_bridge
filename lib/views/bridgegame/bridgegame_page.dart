import 'package:flutter/material.dart';
import '../../components/base_divider.dart';
import '../../constants/colors.dart';
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

  void _update() => setState(() {});


  @override
  void initState() {
    super.initState();
    controller = BridgegameController();
    controller.addListener(_update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.baseColor,
      key: _scaffoldKey,
      body: Column(
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
    );
  }
}