import 'package:flutter/material.dart';

class PixelPainter extends CustomPainter {
  final int width, height;
  final List<Color> pixels;

  PixelPainter({required this.width, required this.height, required this.pixels});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final cellWidth = size.width / width;
    final cellHeight = size.height / height;

    // 塗りつぶし
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final index = y * width + x;
        paint.color = pixels[index];
        final rect = Rect.fromLTWH(
          x * cellWidth,
          y * cellHeight,
          cellWidth,
          cellHeight,
        );
        canvas.drawRect(rect, paint);
      }
    }

    // グリッド線
    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    for (int x = 0; x <= width; x++) {
      canvas.drawLine(
        Offset(x * cellWidth, 0),
        Offset(x * cellWidth, size.height),
        paint,
      );
    }
    for (int y = 0; y <= height; y++) {
      canvas.drawLine(
        Offset(0, y * cellHeight),
        Offset(size.width, y * cellHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PixelPainter oldDelegate) {
    return oldDelegate.pixels != pixels ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
