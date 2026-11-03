import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const EmptyState(this.icon, this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 68, color: const Color(0xFFB5C5D5)),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 5),
        Text(subtitle, style: const TextStyle(color: muted)),
      ],
    ),
  );
}
