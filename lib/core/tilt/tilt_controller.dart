import 'package:flutter/material.dart';

class TiltController {
  final ValueNotifier<Offset> tilt = ValueNotifier(const Offset(0, 0));

  void updatePosition(Offset position, Size screenSize) {
    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;

    final deltaX = (position.dx - centerX) / centerX;
    final deltaY = (position.dy - centerY) / centerY;

    tilt.value = Offset(deltaX, deltaY);
  }

  void dispose() {
    tilt.dispose();
  }
}