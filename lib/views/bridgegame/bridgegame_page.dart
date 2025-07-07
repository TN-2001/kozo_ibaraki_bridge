import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/components/base_divider.dart';
import 'package:kozo_ibaraki_bridge/constants/colors.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/canvas/main_canvas.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/models/pixel_canvas_controller.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/ui/bridgegame_ui.dart';

class BridgegamePage extends StatefulWidget {
  const BridgegamePage({super.key});

  @override
  State<BridgegamePage> createState() => _BridgegamePageState();
}

class _BridgegamePageState extends State<BridgegamePage> {
  late PixelCanvasController controller;

  @override
  void initState() {
    super.initState();
    controller = PixelCanvasController();
    controller.addListener(_update);
    controller.resizeCanvasTo(70, 25);
  }


  void _update() => setState(() {});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.baseColor,
      body: Column(
        children: [
          BridgegameUI(controller: controller,),

          BaseDivider(),

          MainCanvas(controller: controller,),
        ],
      ),
    );
  }
}