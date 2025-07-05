import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/views/main/canvas/main_canvas.dart';
import 'package:kozo_ibaraki_bridge/views/main/ui/main_ui.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MainCanvas(),
          MainUI(),
        ],
      ),
    );
  }
}