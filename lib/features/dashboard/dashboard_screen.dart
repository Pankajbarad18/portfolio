import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ghost_portfolio/features/dashboard/cyber_corners.dart';
import 'package:ghost_portfolio/features/dashboard/cyber_grid_painter.dart';
import 'package:ghost_portfolio/features/dashboard/neural_node.dart';
import '../../core/tilt/tilt_controller.dart';

class Bullet {
  Offset position;
  Offset velocity;

  Bullet(this.position, this.velocity);
}

extension OffsetNormalize on Offset {
  Offset normalize() {
    final length = distance;
    if (length == 0) return this;
    return this / length;
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final TiltController _tiltController = TiltController();

  late final AnimationController _scanController;
  late final Animation<double> _scan;

  final List<Bullet> bullets = [];
  late final Ticker _ticker;
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

    _ticker = createTicker((_) {
      for (final bullet in bullets) {
        bullet.position += bullet.velocity;
      }
      setState(() {});
    })..start();
  }

  @override
  void dispose() {
    _tiltController.dispose();
    _scanController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  void _fireBullet(Offset target) {
    final screenCenter = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );

    final direction = (target - screenCenter).normalize();

    bullets.add(Bullet(screenCenter, direction * 10));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          _fireBullet(details.localPosition);
        },
        child: MouseRegion(
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
                      const NeuralSphere(label: "PROJECTS"),
                      const NeuralSphere(label: "SKILLS"),
                      const NeuralSphere(label: "CONTACT"),
                      const NeuralSphere(label: "EXPERIENCE"),
                      const _SystemStatus(),

                      const CyberCorners(),
                      ...bullets.map((bullet) {
                        return Positioned(
                          left: bullet.position.dx,
                          top: bullet.position.dy,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00FFFF),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF00FFFF,
                                  ).withOpacity(0.8),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
                                        const Color(
                                          0xFF00FFFF,
                                        ).withOpacity(0.15),
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
        child: SizedBox(
          width: 500,
          height: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// CORE TITLE
              const Text(
                "GHOST_PROTOCOL SYSTEM CORE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF2D75),
                  fontSize: 26,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // NeuralSphere(label: "PROJECTS", onHit: () {}),
              // NeuralSphere(label: "SKILLS", onHit: () {}),
              // NeuralSphere(label: "CONTACT", onHit: () {}),
              // NeuralSphere(label: "EXPERIENCE", onHit: () {}),
            ],
          ),
        ),
      ),
    );
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

class _SystemStatus extends StatelessWidget {
  const _SystemStatus();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 40,
      left: 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "STATUS: ONLINE",
            style: TextStyle(
              color: Color(0xFF00FFFF),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "CORE TEMP: 72%",
            style: TextStyle(
              color: Color(0xFF00FFFF),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "SIGNAL: STABLE",
            style: TextStyle(
              color: Color(0xFF00FFFF),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
