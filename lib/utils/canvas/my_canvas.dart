import 'package:flutter/cupertino.dart';

class MyCanvas {
  static void drawGrid(Canvas canvas, Size size) {
    for (int i = 0; i < size.width; i++) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), Paint());
    }
    for (int i = 0; i < size.height; i++) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), Paint());
    }
  }
}