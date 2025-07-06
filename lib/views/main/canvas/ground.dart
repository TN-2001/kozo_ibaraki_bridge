import 'package:flutter/material.dart';

class Ground extends StatelessWidget {
  const Ground({super.key, required this.cellSize});

  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GroundPainter(
        cellSize: cellSize,
      ),
    );
  }
}

class _GroundPainter extends CustomPainter {
  _GroundPainter({
    required this.cellSize,
  });


  final double cellSize;


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
    Rect lrect = Rect.fromLTRB(0, size.height, cellSize * 2, size.height + cellSize);
    canvas.drawRect(lrect, paint);
    Rect rrect = Rect.fromLTRB(size.width - cellSize * 2, size.height, size.width, size.height + cellSize);
    canvas.drawRect(rrect, paint);

    // 土台
    Paint tpaint = Paint()
      ..color = const Color.fromARGB(255, 121, 121, 121)
      ..style = PaintingStyle.fill;
    Rect ltrect = Rect.fromLTRB(-cellSize * 2, size.height + cellSize, cellSize * 2, size.height + cellSize * 4);
    canvas.drawRect(ltrect, tpaint);
    Rect rtrect = Rect.fromLTRB(size.width - cellSize * 2, size.height + cellSize, size.width + cellSize * 2, size.height + cellSize * 4);
    canvas.drawRect(rtrect, tpaint);

    // 地面
    Paint gpaint = Paint()
      ..color = const Color.fromARGB(255, 149, 97, 52)
      ..style = PaintingStyle.fill;
    Path lgpath = Path()
      ..moveTo(-cellSize * 100, size.height + cellSize * 4)
      ..lineTo(cellSize * 2, size.height + cellSize * 4)
      ..lineTo(cellSize * 25, size.height + cellSize * 100)
      ..lineTo(-cellSize * 100, size.height + cellSize * 100)
      ..close();
    canvas.drawPath(lgpath, gpaint);
    Path rgpath = Path()
      ..moveTo(size.width + cellSize * 100, size.height + cellSize * 4)
      ..lineTo(size.width - cellSize * 2, size.height + cellSize * 4)
      ..lineTo(size.width - cellSize * 25, size.height + cellSize * 100)
      ..lineTo(size.width + cellSize * 100, size.height + cellSize * 100)
      ..close();
    canvas.drawPath(rgpath, gpaint);
  }

  @override
  bool shouldRepaint(covariant _GroundPainter oldDelegate) {
    return true;
  }
}