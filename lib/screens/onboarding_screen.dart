import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/screens/main_shell.dart';
import 'package:jojo/widgets/kid_art.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _openApp(context),
                  child: const Text('Skip'),
                ),
              ),
              const Spacer(),
              const KidArt(size: 260),
              const SizedBox(height: 35),
              const Text(
                'A bright future starts\nwith joyful learning',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ink,
                  fontSize: 27,
                  height: 1.18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Discover books, courses and learning activities carefully selected for every curious child.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, height: 1.5),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 25,
                    height: 7,
                    decoration: BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const CircleAvatar(
                    radius: 3.5,
                    backgroundColor: Color(0xFFD5E7F8),
                  ),
                  const SizedBox(width: 6),
                  const CircleAvatar(
                    radius: 3.5,
                    backgroundColor: Color(0xFFD5E7F8),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _openApp(context),
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openApp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }
}
