import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/components/base_divider.dart';
import 'package:kozo_ibaraki_bridge/constants/colors.dart';
import 'package:kozo_ibaraki_bridge/views/main/canvas/main_canvas.dart';
import 'package:kozo_ibaraki_bridge/views/main/models/pixel_canvas_controller.dart';
import 'package:kozo_ibaraki_bridge/views/main/ui/main_ui.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
          MainUI(controller: controller,),

          BaseDivider(),

          MainCanvas(controller: controller,),
        ],
      ),
    );
  }
}