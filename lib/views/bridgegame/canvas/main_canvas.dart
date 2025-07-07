import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/constants/paths.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/canvas/ground.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/canvas/sea.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/models/pixel_canvas_controller.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/canvas/pixel_paint_area.dart';

class MainCanvas extends StatefulWidget {
  const MainCanvas({super.key, required this.controller});

  final PixelCanvasController controller;

  @override
  State<MainCanvas> createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  
  
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {

          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          if (width / height < 16 / 9) {
            height = width / (16 / 9);
          } else if (width / height > 16 / 9) {
            width = height * (16 / 9);
          }

          final cellW = width / controller.gridWidth;
          final cellH = (height / 2) / controller.gridHeight;
          final cellSize = cellW < cellH ? cellW : cellH;
          final canvasWidth = cellSize * controller.gridWidth;
          final canvasHeight = cellSize * controller.gridHeight;

          return Center(

            child: Container(
              width: width,
              height: height,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform(
                    transform: Matrix4.translationValues(0, -height * 0.125, 0),
                    child: Image.asset(ImagePass.cloud),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(-width * 0.3, -height * 0.375, 0),
                    child: Image.asset(ImagePass.sun, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(width * 0.2, -height * 0.375, 0),
                    child: Image.asset(ImagePass.name, width: height, height: height * 0.5,),
                  ),
                  // 海
                  Sea(),
                  Transform(
                    transform: Matrix4.translationValues(-canvasWidth * 0.2, height * 0.375, 0),
                    child: Image.asset(ImagePass.ship, width: height * 0.5, height: height * 0.5,),
                  ),
                  // 土台
                  SizedBox(
                    width: canvasWidth,
                    height: canvasHeight,
                    child: Ground(cellSize: cellSize,),
                  ),
                  // 草
                  Transform(
                    transform: Matrix4.translationValues(-cellSize * (controller.gridWidth * 0.5 - 2) - height * 0.1, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(-cellSize * (controller.gridWidth * 0.5 - 2) - height * 0.3, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(-cellSize * (controller.gridWidth * 0.5 - 2) - height * 0.5, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(-cellSize * (controller.gridWidth * 0.5 - 2) - height * 0.7, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(cellSize * (controller.gridWidth * 0.5 - 2) + height * 0.1, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(cellSize * (controller.gridWidth * 0.5 - 2) + height * 0.3, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(cellSize * (controller.gridWidth * 0.5 - 2) + height * 0.5, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(cellSize * (controller.gridWidth * 0.5 - 2) + height * 0.7, height * 0.25 + cellSize * 4 - height * 0.09, 0),
                    child: Image.asset(ImagePass.grass, width: height * 0.2, height: height * 0.2,),
                  ),
                  SizedBox(
                    width: canvasWidth,
                    height: canvasHeight,
                    child: PixelPaintArea(controller: widget.controller,),
                  ),
                  Container(
                    width: 1,
                    height: canvasHeight,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}





