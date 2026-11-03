import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/screens/onboarding_screen.dart';
import 'package:jojo/widgets/brand_logo.dart';
import 'package:jojo/widgets/kid_art.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandLogo(large: true),
            SizedBox(height: 8),
            Text('Learn • Play • Grow', style: TextStyle(color: muted)),
            SizedBox(height: 38),
            KidArt(size: 215),
          ],
        ),
      ),
    );
  }
}
