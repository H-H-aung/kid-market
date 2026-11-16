import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';

class BrandLogo extends StatelessWidget {
  final bool large;
  const BrandLogo({super.key, this.large = false});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: large ? 58 : 42,
        height: large ? 58 : 42,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(large ? 15 : 11),
          border: Border.all(color: const Color(0xFFE4ECF4)),
          boxShadow: [
            BoxShadow(
              color: ink.withValues(alpha: .08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Transform.scale(
          scale: 1.5,
          child: Image.asset(
            'assets/Kids_world.logo.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            semanticLabel: 'Kids Mart panda logo',
          ),
        ),
      ),
      SizedBox(width: large ? 10 : 8),
      Text(
        'Kids',
        style: TextStyle(
          color: blue,
          fontSize: large ? 30 : 21,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(
        'Mart',
        style: TextStyle(
          color: const Color(0xFFFF9F1C),
          fontSize: large ? 30 : 21,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );
}
