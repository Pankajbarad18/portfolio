import 'package:flutter/material.dart';
import 'core/boot/boot_screen.dart';

void main() {
  runApp(const GhostProtocolApp());
}

class GhostProtocolApp extends StatelessWidget {
  const GhostProtocolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GHOST_PROTOCOL',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0F1F),
        fontFamily: 'JetBrainsMono',
      ),
      home: const BootScreen(),
    );
  }
}