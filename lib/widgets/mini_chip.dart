import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';

class MiniChip extends StatelessWidget {
  final String text;
  const MiniChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F4FF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: blue,
      ),
    ),
  );
}
