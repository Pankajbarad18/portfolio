import 'package:flutter/material.dart';

class CyberGridPainter extends CustomPainter {
  final Offset tilt;

  CyberGridPainter(this.tilt);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8A2BE2).withOpacity(0.12)
      ..strokeWidth = 1;

    const spacing = 40.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x + tilt.dx * 10, 0),
        Offset(x + tilt.dx * 10, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y + tilt.dy * 10),
        Offset(size.width, y + tilt.dy * 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
