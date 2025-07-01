import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/views/main/main_canvas.dart';
import 'package:kozo_ibaraki_bridge/views/main/ui/main_ui.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

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