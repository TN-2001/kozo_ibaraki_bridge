import 'package:flutter/material.dart';
import 'package:kozo_ibaraki_bridge/constants/paths.dart';
import 'package:kozo_ibaraki_bridge/utils/camera.dart';
import 'package:kozo_ibaraki_bridge/utils/my_painter.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/canvas/ground.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/canvas/sea.dart';
import 'package:kozo_ibaraki_bridge/views/bridgegame/models/bridgegame_controller.dart';

class BridgegameCanvas extends StatelessWidget {
  BridgegameCanvas({super.key, required this.controller});

  final BridgegameController controller;
  final Camera camera = Camera(0,Offset.zero,Offset.zero); // カメラ


  // カメラの拡大率を取得
  double _getCameraScale(Rect screenRect, Rect worldRect){
    double width = worldRect.width;
    double height = worldRect.height;
    if(width == 0 && height == 0){
      width = 100;
    }
    if(screenRect.width / width < screenRect.height / height){
      return screenRect.width / width;
    }
    else{
      return screenRect.height / height;
    }
  }

  Widget paintCanvas(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onPanStart: (details) {
          if (controller.isCalculation) {
            return;
          }
          controller.saveToUndo();
          controller.paintPixel(camera.screenToWorld(details.localPosition));
        },
        onPanUpdate: (details) {
          if (controller.isCalculation) {
            return;
          }
          controller.paintPixel(camera.screenToWorld(details.localPosition));
        },
        onTapDown: (details) {
          controller.saveToUndo();
          controller.paintPixel(camera.screenToWorld(details.localPosition));
        },
        child: CustomPaint(
          painter: BridgegamePainter(data: controller, camera: camera,),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

          camera.init(
            _getCameraScale(Rect.fromLTRB((width/10), (height/4), width-(width/10), height-(height/4)), controller.nodeRect), 
            controller.nodeRect.center, 
            Offset(constraints.maxWidth / 2, constraints.maxHeight / 2)
          );
          final double canvasWidth = camera.scale * controller.nodeRect.width;
          final double canvasHeight = camera.scale * controller.nodeRect.height;
          final double cellSize = camera.scale;


          return Center(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 雲
                  Transform(
                    transform: Matrix4.translationValues(0, -height * 0.125, 0),
                    child: Image.asset(ImagePass.cloud),
                  ),
                  // 太陽
                  Transform(
                    transform: Matrix4.translationValues(-width * 0.3, -height * 0.375, 0),
                    child: Image.asset(ImagePass.sun, width: height * 0.2, height: height * 0.2,),
                  ),
                  // 名前
                  Transform(
                    transform: Matrix4.translationValues(width * 0.2, -height * 0.375, 0),
                    child: Image.asset(ImagePass.name, width: height, height: height * 0.5,),
                  ),
                  // 海
                  SizedBox(
                    width: canvasWidth,
                    height: canvasHeight,
                    child: Sea(),
                  ),
                  // 船
                  Transform(
                    transform: Matrix4.translationValues(-canvasWidth * 0.2, height * 0.375, 0),
                    child: Image.asset(ImagePass.ship, width: height * 0.5, height: height * 0.5,),
                  ),
                  // 土台
                  SizedBox(
                    width: canvasWidth,
                    height: canvasHeight,
                    child: Ground(constWidth: cellSize*2, canvasWidth: canvasWidth, canvasHeight: canvasHeight,),
                  ),
                  // トラック
                  if (!controller.isCalculation)...{
                    Transform(
                      transform: Matrix4.translationValues(canvasWidth * 0.5 + height * 0.075 + canvasHeight * 0.05, canvasHeight * 0.5 - cellSize * 3, 0),
                      child: Image.asset(ImagePass.truck, width: height * 0.15, height: height * 0.15,),
                    ),
                  } else ...{
                    Transform(
                      transform: Matrix4.translationValues(- canvasWidth * 0.5 - height * 0.075 - canvasHeight * 0.05, canvasHeight * 0.5 - cellSize * 3, 0),
                      child: Image.asset(ImagePass.truck, width: height * 0.15, height: height * 0.15,),
                    ),
                  },
                  // 
                  paintCanvas(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class BridgegamePainter extends CustomPainter {
  BridgegamePainter({required this.data, required this.camera,});

  final BridgegameController data;
  Camera camera; // カメラ

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    if (!data.isCalculation) {
      // 要素
      // _drawElem(false, canvas); // 要素
      _drawElemPaint(canvas, size);
      _drawElemEdge(false, canvas); // 要素の辺

      // 中心線
      paint = Paint()
        ..color = const Color.fromARGB(255, 0, 0, 0)
        ..style = PaintingStyle.stroke;
      canvas.drawLine(camera.worldToScreen(data.getNode(35).pos), camera.worldToScreen(data.getNode(71*25+35).pos), paint);

      // 矢印
      double arrowSize = 0.2;

      if(data.powerIndex == 0){ // 3点曲げ
        paint.color = const Color.fromARGB(255, 0, 0, 0);
        paint.style = PaintingStyle.fill;
        paint.strokeWidth = 3.0;
        for(int i = 34; i <= 36; i++){
          Offset pos = data.getNode(i).pos;
          MyPainter.arrow(camera.worldToScreen(pos), camera.worldToScreen(Offset(pos.dx, pos.dy-1.5)), arrowSize*camera.scale, const Color.fromARGB(255, 0, 63, 95), canvas);
        }
      }else if(data.powerIndex == 1){ // 4点曲げ
        paint.color = const Color.fromARGB(255, 0, 0, 0);
        paint.style = PaintingStyle.fill;
        paint.strokeWidth = 3.0;
        for(int i = 22; i <= 24; i++){
          Offset pos = data.getNode(i).pos;
          MyPainter.arrow(camera.worldToScreen(pos), camera.worldToScreen(Offset(pos.dx, pos.dy-1.5)), arrowSize*camera.scale, const Color.fromARGB(255, 0, 63, 95), canvas);
        }
        for(int i = 46; i <= 48; i++){
          Offset pos = data.getNode(i).pos;
          MyPainter.arrow(camera.worldToScreen(pos), camera.worldToScreen(Offset(pos.dx, pos.dy-1.5)), arrowSize*camera.scale, const Color.fromARGB(255, 0, 63, 95), canvas);
        }
      }

      // 体積
      int elemLength = data.onElemListLength;
      Color color = Colors.black;
      if(elemLength > 1000){
        color = Colors.red;
      }
      MyPainter.text(canvas, const Offset(10, 10), "体積：$elemLength", 16, color, true, size.width, );
    } else {
      if (data.powerIndex == 0) {
        data.dispScale = 90.0; // 3点曲げの変位倍率
        // data.dispScale = 3;
      } else if (data.powerIndex == 1) {
        data.dispScale = 100.0; // 4点曲げの変位倍率
      } else {
        data.dispScale = 100.0; // その他の変位倍率
      }
      data.dispScale /= (data.vvar * data.onElemListLength);

      // 要素
      _drawElem(true, canvas); // 要素
      _drawElemEdge(true, canvas); // 要素の辺

      // 選択
      paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      if(data.selectedElemIndex >= 0){
        if(data.getElem(data.selectedElemIndex).e > 0){
          final path = Path();
          for(int j = 0; j < 4; j++){
            Offset pos = camera.worldToScreen(
              data.getElem(data.selectedElemIndex).nodeList[j].pos + data.getElem(data.selectedElemIndex).nodeList[j].becPos*data.dispScale);
            if(j == 0){
              path.moveTo(pos.dx, pos.dy);
            }else{
              path.lineTo(pos.dx, pos.dy);
            }
          }
          path.close();
          canvas.drawPath(path, paint);
        }
      }
      if(data.selectedElemIndex >= 0){
        if(data.getElem(data.selectedElemIndex).e > 0){
          MyPainter.text(canvas, camera.worldToScreen(data.getElem(data.selectedElemIndex).nodeList[0].pos + data.getElem(data.selectedElemIndex).nodeList[0].becPos*data.dispScale), 
            MyPainter.doubleToString(data.getSelectedResult(data.selectedElemIndex), 3), 14, Colors.black, true, size.width);
        }
      }

      // 虹色
      if(size.width > size.height){
        Rect cRect = Rect.fromLTRB(size.width - 85, 50, size.width - 60, size.height - 50);
        if(cRect.height > 500){
          cRect = Rect.fromLTRB(cRect.left, size.height/2-250, cRect.right, size.height/2+250);
        }
        // 虹色
        MyPainter.rainbowBand(canvas, cRect, 50);

        // 最大最小
        MyPainter.text(canvas, Offset(cRect.left+5, cRect.top-20), 
          "大", 14, Colors.black, true, size.width);
        MyPainter.text(canvas, Offset(cRect.left+5, cRect.bottom+5), 
          "小", 14, Colors.black, true, size.width);
        
        // ラベル
        MyPainter.text(canvas, Offset(cRect.right+5, cRect.center.dy-40), "引張の力", 14, Colors.black, true, 14);
      }else{
        Rect cRect = Rect.fromLTRB(50, size.height - 75, size.width - 50, size.height - 50);
        if(cRect.width > 500){
          cRect = Rect.fromLTRB(size.width/2-250, cRect.top, size.width/2+250, cRect .bottom);
        }
        // 虹色
        MyPainter.rainbowBand(canvas, cRect, 50);

        // 最大最小
        MyPainter.text(canvas, Offset(cRect.right+5, cRect.top+3), 
          "大", 14, Colors.black, true, size.width);
        MyPainter.text(canvas, Offset(cRect.left-20, cRect.top+3), 
          "小", 14, Colors.black, true, size.width);
        
        // ラベル
        MyPainter.text(canvas, Offset(cRect.center.dx-20, cRect.bottom+5), "引張の力", 14, Colors.black, true, size.width);
      }

      // 点数
      MyPainter.text(canvas, const Offset(10, 10), "${data.resultPoint.toStringAsFixed(2)}点", 32, Colors.black, true, size.width, );

      // 体積
      MyPainter.text(canvas, const Offset(10, 50), "体積：${data.onElemListLength}", 16, Colors.black, true, size.width, );
    }
  }

  // 要素の辺
  void _drawElemEdge(bool isAfter, Canvas canvas){
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 220, 220, 220)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.2;

    if(data.elemListLength > 0){
      for(int i = 0; i < data.elemListLength; i++){
        if((data.getElem(i).e > 0 && isAfter) || !isAfter){
          final path = Path();
          for(int j = 0; j < 4; j++){
            Offset pos;
            if(!isAfter){
              pos = camera.worldToScreen(data.getElem(i).nodeList[j].pos);
            }else{
              pos = camera.worldToScreen(data.getElem(i).nodeList[j].pos + data.getElem(i).nodeList[j].becPos*data.dispScale);
            }

            if(j == 0){
              path.moveTo(pos.dx, pos.dy);
            }else{
              path.lineTo(pos.dx, pos.dy);
            }
          }
          path.close();
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  // 要素
  void _drawElem(bool isAfter, Canvas canvas){
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 49, 49, 49);

    for(int i = 0; i < data.elemListLength; i++){
      if(data.getElem(i).e > 0 || data.pixelColors[i].a != 0){
        if(isAfter && (data.selectedResultMax != 0 || data.selectedResultMin != 0)){
          paint.color = MyPainter.getColor((data.getSelectedResult(i) - data.selectedResultMin) / (data.selectedResultMax - data.selectedResultMin) * 100);
        }
        else if(!isAfter){
          if(data.getElem(i).isCanPaint){
            // paint.color = const Color.fromARGB(255, 184, 25, 63);
            paint.color = data.pixelColors[i];
          }
          else{
            // paint.color = const Color.fromARGB(255, 106, 23, 43);
            paint.color = data.pixelColors[i];
          }
        }

        final path = Path();
        for(int j = 0; j < 4; j++){
          Offset pos;
          if(!isAfter){
            pos = camera.worldToScreen(data.getElem(i).nodeList[j].pos);
          }else{
            pos = camera.worldToScreen(data.getElem(i).nodeList[j].pos + data.getElem(i).nodeList[j].becPos*data.dispScale);
          }
          if(j == 0){
            path.moveTo(pos.dx, pos.dy);
          }else{
            path.lineTo(pos.dx, pos.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawElemPaint(Canvas canvas, Size size){
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 49, 49, 49);

    for(int i = 0; i < data.elemListLength; i++){
      if(data.getElem(i).isCanPaint){
        paint.color = data.pixelColors[i];
      }
      else{
        paint.color = data.pixelColors[i];
      }

      final path = Path();
      for(int j = 0; j < 4; j++){
        Offset pos;
        pos = camera.worldToScreen(data.getElem(i).nodeList[j].pos);
        if(j == 0){
          path.moveTo(pos.dx, pos.dy);
        }else{
          path.lineTo(pos.dx, pos.dy);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }


  @override
  bool shouldRepaint(covariant BridgegamePainter oldDelegate) {
    return false;
  }
}