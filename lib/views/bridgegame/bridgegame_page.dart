import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/components/base_divider.dart';
import 'package:kozo_ibaraki_bridge/constants/colors.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/canvas/bridgegame_canvas.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/models/bridgegame_controller.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/ui/bridgegame_ui.dart';

class BridgegamePage extends StatefulWidget {
  const BridgegamePage({super.key});

  @override
  State<BridgegamePage> createState() => _BridgegamePageState();
}

class _BridgegamePageState extends State<BridgegamePage> {
  late BridgegameController controller;

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
      body: Column(
        children: [
          BridgegameUI(controller: controller,),

          BaseDivider(),

          BridgegameCanvas(controller: controller,),
        ],
      ),
    );
  }
}