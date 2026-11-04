import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';

class InfoBox extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoBox(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE4ECF4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: blue, size: 20),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ),
  );
}
