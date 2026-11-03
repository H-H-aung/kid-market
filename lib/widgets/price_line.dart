import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';

class PriceLine extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;
  const PriceLine(this.label, this.value, {super.key, this.strong = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: strong ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: strong ? blue : ink,
            fontSize: strong ? 17 : 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}
