import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/views/main/canvas/pixel_painter.dart';
import '../models/pixel_canvas_controller.dart';

class PixelPaintArea extends StatefulWidget {
  const PixelPaintArea({super.key, required this.controller});
  
  final PixelCanvasController controller;

  @override
  State<PixelPaintArea> createState() => _PixelPaintAreaState();
}

class _PixelPaintAreaState extends State<PixelPaintArea> {
  final GlobalKey _paintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellW = constraints.maxWidth / controller.gridWidth;
        final cellH = constraints.maxHeight / controller.gridHeight;
        final cellSize = cellW < cellH ? cellW : cellH;
        final canvasWidth = cellSize * controller.gridWidth;
        final canvasHeight = cellSize * controller.gridHeight;

        return Center(
          child: GestureDetector(
            onPanStart: (details) {
              controller.saveToUndo();
              final box = _paintKey.currentContext?.findRenderObject() as RenderBox;
              controller.paintPixel(box.globalToLocal(details.globalPosition), box.size);
            },
            onPanUpdate: (details) {
              final box = _paintKey.currentContext?.findRenderObject() as RenderBox;
              controller.paintPixel(box.globalToLocal(details.globalPosition), box.size);
            },
            onTapDown: (details) {
              controller.saveToUndo();
              final box = _paintKey.currentContext?.findRenderObject() as RenderBox;
              controller.paintPixel(box.globalToLocal(details.globalPosition), box.size);
            },
            child: SizedBox(
              key: _paintKey,
              width: canvasWidth,
              height: canvasHeight,
              child: CustomPaint(
                painter: PixelPainter(
                  width: controller.gridWidth,
                  height: controller.gridHeight,
                  pixels: controller.pixelColors,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
