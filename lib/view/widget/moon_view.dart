import 'package:flutter/material.dart';

/// 月亮
class MoonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MoonPainter(),
      size: Size(36, 36),
    );
  }
}

class _MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    final paint2 = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.white12
      ..isAntiAlias = true
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..cubicTo(-size.width / 4, size.height / 4, size.width / 4,
          size.height / 4 * 5, size.width, size.height / 4 * 3)
      ..cubicTo(size.width / 2, size.height, size.width / 8, size.height / 4,
          size.width / 2, 0)
      ..close();

    canvas.drawPath(path, paint2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_MoonPainter oldDelegate) {
    return false;
  }
}
