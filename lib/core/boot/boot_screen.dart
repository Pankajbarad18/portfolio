import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_screen.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final List<String> lines = [
    "> Establishing Neural Link...",
    "> Accessing GHOST_PROTOCOL.exe",
    "> Loading Flutter Engine...",
    "> Injecting UI Modules...",
    "> Welcome, User.",
  ];

  String displayedText = "";
  int lineIndex = 0;

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  Future<void> _startBootSequence() async {
    for (String line in lines) {
      await _typeLine(line);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => const DashboardScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Future<void> _typeLine(String line) async {
    for (int i = 0; i <= line.length; i++) {
      await Future.delayed(const Duration(milliseconds: 25));
      setState(() {
        displayedText += line.substring(i - 1 < 0 ? 0 : i - 1, i);
      });
    }
    displayedText += "\n";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            displayedText,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}