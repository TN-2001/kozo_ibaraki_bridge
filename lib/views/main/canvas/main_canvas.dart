import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/constants/paths.dart';

class MainCanvas extends StatefulWidget {
  const MainCanvas({super.key});

  @override
  State<MainCanvas> createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Stack(
          children: [
            Image.asset(ImagePass.cloud),
            // CanvasArea(),
          ],
        ),
      ),
    );
  }
}





