import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/screens/onboarding_screen.dart';
import 'package:kids_mart/widgets/brand_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF4FF), Color(0xFFFAFCFF), Color(0xFFFFF1E2)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: -100,
              right: -100,
              child: _SoftCircle(size: 300, color: Color(0xFFDCEAFF)),
            ),
            const Positioned(
              bottom: -90,
              left: -100,
              child: _SoftCircle(size: 280, color: Color(0xFFFFE9CE)),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 620;
                  final artSize = math.min(
                    constraints.maxWidth * .72,
                    compact ? 160.0 : 260.0,
                  );
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: compact ? 20 : 36,
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
                          duration: Duration(
                            milliseconds: reduceMotion ? 0 : 700,
                          ),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 16 * (1 - value)),
                              child: child,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ExcludeSemantics(
                                child: _SplashArtwork(size: artSize),
                              ),
                              SizedBox(height: compact ? 20 : 32),
                              const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: BrandLogo(large: true),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Learn · Play · Grow',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Big adventures for little minds.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: compact ? 24 : 42),
                              const ExcludeSemantics(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _Dot(blue),
                                    SizedBox(width: 7),
                                    _Dot(Color(0xFFFFB650)),
                                    SizedBox(width: 7),
                                    _Dot(Color(0xFF62CDB3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashArtwork extends StatelessWidget {
  final double size;
  const _SplashArtwork({required this.size});
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * .88,
          height: size * .88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: .55),
            border: Border.all(
              color: Colors.white.withValues(alpha: .9),
              width: 2,
            ),
          ),
        ),
        Container(
          width: size * .69,
          height: size * .69,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFDCEBFF),
          ),
        ),
        Transform.rotate(
          angle: -.10,
          child: Container(
            width: size * .47,
            height: size * .59,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4AABFF), Color(0xFF1688F8)],
              ),
              borderRadius: BorderRadius.circular(size * .09),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: blue.withValues(alpha: .23),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: size * .25,
                ),
                SizedBox(height: size * .06),
                Container(
                  width: size * .22,
                  height: size * .018,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: size * .03),
                Container(
                  width: size * .14,
                  height: size * .018,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .45),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: size * .08,
          right: size * .04,
          child: _OrbitTile(
            icon: Icons.star_rounded,
            color: const Color(0xFFFFE6AE),
            foreground: const Color(0xFFE9A222),
            size: size * .23,
            angle: .14,
          ),
        ),
        Positioned(
          bottom: size * .11,
          left: size * .01,
          child: _OrbitTile(
            icon: Icons.extension_rounded,
            color: const Color(0xFFD4F4E8),
            foreground: const Color(0xFF35A989),
            size: size * .23,
            angle: -.18,
          ),
        ),
        Positioned(
          bottom: size * .12,
          right: size * .06,
          child: _OrbitTile(
            icon: Icons.favorite_rounded,
            color: const Color(0xFFFFE0E9),
            foreground: const Color(0xFFE77A9A),
            size: size * .17,
            angle: .13,
          ),
        ),
        Positioned(
          left: size * .12,
          top: size * .15,
          child: Icon(
            Icons.auto_awesome_rounded,
            size: size * .09,
            color: const Color(0xFFFFB650),
          ),
        ),
      ],
    ),
  );
}

class _OrbitTile extends StatelessWidget {
  final IconData icon;
  final Color color, foreground;
  final double size, angle;
  const _OrbitTile({
    required this.icon,
    required this.color,
    required this.foreground,
    required this.size,
    required this.angle,
  });
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: angle,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * .3),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(icon, color: foreground, size: size * .52),
    ),
  );
}

class _SoftCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _SoftCircle({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: .55),
      ),
    ),
  );
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot(this.color);
  @override
  Widget build(BuildContext context) => Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
