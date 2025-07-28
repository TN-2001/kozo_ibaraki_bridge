import 'package:flutter/material.dart';

class Sea extends StatelessWidget {
  const Sea({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: _SeaPainter(),
      ),
    );
  }
}

class _SeaPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    // 海の描画
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 218, 233, 246)
      ..style = PaintingStyle.fill;
    Rect rect = Rect.fromLTRB(0, size.height * 1.25, size.width, size.height * 4);
    canvas.drawRect(rect, paint);
    paint.color = const Color.fromARGB(255, 189, 217, 241);
    rect = Rect.fromLTRB(0, size.height * (1.25 + 0.06), size.width, size.height * 4);
    canvas.drawRect(rect, paint);
    paint.color = const Color.fromARGB(255, 153, 199, 234);
    rect = Rect.fromLTRB(0, size.height * (1.25 + 0.06 * 2), size.width, size.height * 4);
    canvas.drawRect(rect, paint);
    paint.color = const Color.fromARGB(255, 96, 178, 228);
    rect = Rect.fromLTRB(0, size.height * (1.25 + 0.06 * 3), size.width, size.height * 10);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}