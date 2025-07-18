import 'package:flutter/material.dart';

import '../../../constants/paths.dart';

class Ground extends StatelessWidget {
  const Ground({super.key, required this.constWidth, required this.canvasWidth, required this.canvasHeight});

  final double canvasWidth;
  final double canvasHeight;
  final double constWidth;


  Widget grass(double posx) {
    return Transform(
      transform: Matrix4.translationValues(posx, canvasHeight * 0.651 - canvasHeight * 0.2, 0),
      child: Image.asset(ImagePass.grass, width: canvasHeight * 0.4, height: canvasHeight * 0.4,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 地面
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: _GroundPainter(
              constWidth: constWidth,
            ),
          ),
        ),
        // 草
        grass(constWidth - canvasWidth * 0.5 - canvasHeight * (0.2 + 0.4 * 0)),
        grass(constWidth - canvasWidth * 0.5 - canvasHeight * (0.2 + 0.4 * 1)),
        grass(constWidth - canvasWidth * 0.5 - canvasHeight * (0.2 + 0.4 * 2)),
        grass(constWidth - canvasWidth * 0.5 - canvasHeight * (0.2 + 0.4 * 3)),
        grass(constWidth - canvasWidth * 0.5 - canvasHeight * (0.2 + 0.4 * 4)),
        grass(constWidth - canvasWidth * 0.5 - canvasHeight * (0.2 + 0.4 * 5)),
        grass(constWidth - canvasWidth * 0.5 - canvasHeight * (0.2 + 0.4 * 6)),
        grass(- constWidth + canvasWidth * 0.5 + canvasHeight * (0.2 + 0.4 * 0)),
        grass(- constWidth + canvasWidth * 0.5 + canvasHeight * (0.2 + 0.4 * 1)),
        grass(- constWidth + canvasWidth * 0.5 + canvasHeight * (0.2 + 0.4 * 2)),
        grass(- constWidth + canvasWidth * 0.5 + canvasHeight * (0.2 + 0.4 * 3)),
        grass(- constWidth + canvasWidth * 0.5 + canvasHeight * (0.2 + 0.4 * 4)),
        grass(- constWidth + canvasWidth * 0.5 + canvasHeight * (0.2 + 0.4 * 5)),
        grass(- constWidth + canvasWidth * 0.5 + canvasHeight * (0.2 + 0.4 * 6)),
      ],
    );
  }
}

class _GroundPainter extends CustomPainter {
  _GroundPainter({
    required this.constWidth,
  });


  final double constWidth;


  @override
  void paint(Canvas canvas, Size size) {
    // final paint = Paint();
    // for (int y = 0; y < gridHeight; y++) {
    //   for (int x = 0; x < gridWidth; x++) {
    //     canvas.drawRect(
    //       Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1),
    //       paint,
    //     );
    //   }
    // }

    // 拘束
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.fill;
    Rect lrect = Rect.fromLTRB(0, size.height, constWidth, size.height + constWidth / 2);
    canvas.drawRect(lrect, paint);
    Rect rrect = Rect.fromLTRB(size.width - constWidth, size.height, size.width, size.height + constWidth / 2);
    canvas.drawRect(rrect, paint);

    // 土台
    Paint tpaint = Paint()
      ..color = const Color.fromARGB(255, 158, 158, 158)
      ..style = PaintingStyle.fill;
    Rect ltrect = Rect.fromLTRB(lrect.left - constWidth * 2, lrect.bottom, lrect.right, lrect.bottom + constWidth * 2);
    canvas.drawRect(ltrect, tpaint);
    Rect rtrect = Rect.fromLTRB(rrect.left, rrect.bottom, rrect.right + constWidth * 2, rrect.bottom + constWidth * 2);
    canvas.drawRect(rtrect, tpaint);

    // 地面
    Paint gpaint = Paint()
      ..color = const Color.fromARGB(255, 149, 97, 52)
      ..style = PaintingStyle.fill;
    Path lgpath = Path()
      ..moveTo(lrect.right - size.height * 4, size.height * 1.15)
      ..lineTo(lrect.right, size.height * 1.15)
      ..lineTo(lrect.right + size.height * 0.75, size.height * (1.15 + 4))
      ..lineTo(lrect.right - size.height * 4, size.height * (1.15 + 4))
      ..close();
    canvas.drawPath(lgpath, gpaint);
    Path rgpath = Path()
      ..moveTo(rrect.left + size.height * 4, size.height * 1.15)
      ..lineTo(rrect.left, size.height * 1.15)
      ..lineTo(rrect.left - size.height * 0.75, size.height * (1.15 + 4))
      ..lineTo(rrect.left + size.height * 4, size.height * (1.15 + 4))
      ..close();
    canvas.drawPath(rgpath, gpaint);

    // 道路
    Rect lTrackRect = Rect.fromLTRB(- constWidth * 2, size.height, - constWidth, size.height + constWidth / 2);
    canvas.drawRect(lTrackRect, paint);
    Rect rTrackRect = Rect.fromLTRB(size.width + constWidth, size.height, size.width + constWidth * 2, size.height + constWidth / 2);
    canvas.drawRect(rTrackRect, paint);

    Paint tTrackPaint = Paint()
      ..color = const Color.fromARGB(255, 113, 113, 113)
      ..style = PaintingStyle.fill;
    Rect lTrackTRect = Rect.fromLTRB(- size.height * 4, size.height - constWidth, - constWidth / 10, size.height);
    canvas.drawRect(lTrackTRect, tTrackPaint);
    Rect rTrackTRect = Rect.fromLTRB(size.width + constWidth / 10, size.height - constWidth, size.width + size.height * 4, size.height);
    canvas.drawRect(rTrackTRect, tTrackPaint);
    Paint tTrackSPaint = Paint()
      ..color = const Color.fromARGB(255, 130, 130, 130)
      ..style = PaintingStyle.fill;
    Rect lTrackTSRect = Rect.fromLTRB(- size.height * 4, size.height - constWidth * 0.47, - constWidth / 10, size.height - constWidth * 0.53);
    canvas.drawRect(lTrackTSRect, tTrackSPaint);
    Rect rTrackTSRect = Rect.fromLTRB(size.width + constWidth / 10, size.height - constWidth * 0.47, size.width + size.height * 4, size.height - constWidth * 0.53);
    canvas.drawRect(rTrackTSRect, tTrackSPaint);
  }

  @override
  bool shouldRepaint(covariant _GroundPainter oldDelegate) {
    return true;
  }
}