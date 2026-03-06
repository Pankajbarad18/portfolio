import 'dart:math';

import 'package:flutter/material.dart';

class NeuralSphere extends StatefulWidget {
  final String label;

  const NeuralSphere({super.key, required this.label});

  @override
  State<NeuralSphere> createState() => _NeuralSphereState();
}

class _NeuralSphereState extends State<NeuralSphere> {
  final Random random = Random();

  double top = 200;
  double left = 200;

  @override
  void initState() {
    super.initState();
    _moveSphere();
  }

  void _moveSphere() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));

      final size = MediaQuery.of(context).size;

      setState(() {
        left = random.nextDouble() * (size.width - 80);
        top = random.nextDouble() * (size.height - 80);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      left: left,
      top: top,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color.fromARGB(255, 57, 122, 122),
              Color.fromARGB(255, 8, 50, 97),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 137, 160, 160).withOpacity(0.8),
              blurRadius: 20,
              spreadRadius: 3,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 255, 255, 255),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
