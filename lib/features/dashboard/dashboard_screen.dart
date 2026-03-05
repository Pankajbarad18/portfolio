import 'package:flutter/material.dart';
import 'package:ghost_portfolio/features/dashboard/cyber_grid_painter.dart';
import '../../core/tilt/tilt_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final TiltController _tiltController = TiltController();

  late final AnimationController _scanController;
  late final Animation<double> _scan;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _scan = Tween<double>(
      begin: -1,
      end: 1,
    ).animate(CurvedAnimation(parent: _scanController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _tiltController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: MouseRegion(
        onHover: (event) {
          _tiltController.updatePosition(event.position, screenSize);
        },
        child: Stack(
          children: [
            ValueListenableBuilder<Offset>(
              valueListenable: _tiltController.tilt,
              builder: (context, tilt, child) {
                final maxAngle = 0.15;

                return Stack(
                  children: [
                    _BackgroundLayer(tilt: tilt),
                    AnimatedBuilder(
                      animation: _scan,
                      builder: (context, child) {
                        return Positioned.fill(
                          child: IgnorePointer(
                            child: FractionallySizedBox(
                              heightFactor: 0.15,
                              alignment: Alignment(0, _scan.value),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF00FFFF).withOpacity(0.15),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Center(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0015)
                          ..rotateX(-tilt.dy * maxAngle)
                          ..rotateY(tilt.dx * maxAngle),
                        child: child,
                      ),
                    ),
                  ],
                );
              },
              child: const _DashboardLayout(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardLayout extends StatefulWidget {
  const _DashboardLayout();

  @override
  State<_DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<_DashboardLayout>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final value = _pulse.value;

          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFF2D75,
                  ).withOpacity(0.25 + (value * 0.25)),
                  blurRadius: 50 + (value * 40),
                  spreadRadius: 8,
                ),
              ],
            ),
            child: child,
          );
        },
        child: const Text(
          "GHOST_PROTOCOL SYSTEM CORE",
          style: TextStyle(
            color: Color(0xFFFF2D75),
            fontSize: 26,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
    // return Container(
    //   width: 1000,
    //   height: 600,
    //   decoration: BoxDecoration(
    //     color: Colors.black.withOpacity(0.6),
    //     border: Border.all(
    //       color: const Color.fromARGB(255, 31, 36, 191),
    //       width: 1.5,
    //     ),
    //     boxShadow: [
    //       BoxShadow(
    //         color: const Color.fromARGB(255, 51, 90, 153).withOpacity(0.5),
    //         blurRadius: 20,
    //         spreadRadius: 2,
    //       ),
    //     ],
    //   ),
    //   child: const Center(
    //     child: Text(
    //       "GHOST_PROTOCOL SYSTEM CORE",
    //       style: TextStyle(
    //         fontSize: 28,
    //         letterSpacing: 2,
    //         color: Colors.pinkAccent,
    //       ),
    //     ),
    //   ),
    
    // );
  }
}

class _BackgroundLayer extends StatelessWidget {
  final Offset tilt;

  const _BackgroundLayer({required this.tilt});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🌌 1️⃣ Deep Space Base
        Transform.translate(
          offset: Offset(tilt.dx * 40, tilt.dy * 40),
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.3, -0.4),
                radius: 1.4,
                colors: [
                  Color(0xFF1A0F2E),
                  Color(0xFF0B0618),
                  Color(0xFF05030C),
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),

        /// ☁️ 2️⃣ Nebula Cloud - Top Right
        Positioned.fill(
          child: IgnorePointer(
            child: Transform.translate(
              offset: Offset(tilt.dx * 80, tilt.dy * 80),
              child: Opacity(
                opacity: 0.25,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.6, -0.5),
                      radius: 1.2,
                      colors: [Color(0xFF6A0DAD), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// ☁️ 3️⃣ Nebula Cloud - Bottom Left
        Positioned.fill(
          child: IgnorePointer(
            child: Transform.translate(
              offset: Offset(tilt.dx * 120, tilt.dy * 120),
              child: Opacity(
                opacity: 0.18,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.7, 0.8),
                      radius: 1.3,
                      colors: [Color(0xFF2E0854), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// ✨ 4️⃣ Subtle Energy Atmosphere
        Positioned.fill(
          child: IgnorePointer(
            child: Transform.translate(
              offset: Offset(tilt.dx * 150, tilt.dy * 150),
              child: Opacity(
                opacity: 0.18,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [Color(0xFF7B00FF), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// 🧩 5️⃣ Cyber Grid
        CustomPaint(size: Size.infinite, painter: CyberGridPainter(tilt)),
      ],
    );
  }
}
