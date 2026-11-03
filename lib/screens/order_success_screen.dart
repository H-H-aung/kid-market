import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/widgets/kid_art.dart';

class OrderSuccessScreen extends StatelessWidget {
  final VoidCallback onContinueShopping;
  const OrderSuccessScreen({super.key, required this.onContinueShopping});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              const KidArt(size: 210),
              const SizedBox(height: 22),
              const Text(
                'Thank You!',
                style: TextStyle(
                  color: ink,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your items have been added\nto cart successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, height: 1.5),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    onContinueShopping();
                    Navigator.pop(context);
                  },
                  child: const Text('Continue Shopping'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('View Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
