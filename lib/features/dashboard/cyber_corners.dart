import 'package:flutter/material.dart';

class CyberCorners extends StatelessWidget {
  const CyberCorners({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // TOP LEFT
        Positioned(
          top: 20,
          left: 20,
          child: corner(),
        ),

        // TOP RIGHT
        Positioned(
          top: 20,
          right: 20,
          child: Transform.rotate(
            angle: 1.5708,
            child: corner(),
          ),
        ),

        // BOTTOM LEFT
        Positioned(
          bottom: 20,
          left: 20,
          child: Transform.rotate(
            angle: -1.5708,
            child: corner(),
          ),
        ),

        // BOTTOM RIGHT
        Positioned(
          bottom: 20,
          right: 20,
          child: Transform.rotate(
            angle: 3.1416,
            child: corner(),
          ),
        ),
      ],
    );
  }

  Widget corner() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: CornerPainter(),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}