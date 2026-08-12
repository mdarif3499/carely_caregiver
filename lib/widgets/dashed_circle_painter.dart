import 'dart:math';
import 'package:flutter/material.dart';

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  DashedCirclePainter({
    this.color = Colors.purple,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = min(size.width / 2, size.height / 2);
    final Offset center = Offset(size.width / 2, size.height / 2);

    const double startAngle = -pi / 2;
    final double circumference = 2 * pi * radius;
    final double dashAngle = (dashWidth / circumference) * 2 * pi;
    final double spaceAngle = (dashSpace / circumference) * 2 * pi;

    double currentAngle = startAngle;
    while (currentAngle < startAngle + 2 * pi) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle,
        dashAngle,
        false,
        paint,
      );
      currentAngle += dashAngle + spaceAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
