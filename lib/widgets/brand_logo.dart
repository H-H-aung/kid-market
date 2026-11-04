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
        width:  large ? 54 : 38,
        height: large ? 54 : 38,
        decoration: BoxDecoration(
          color: blue,
          borderRadius: BorderRadius.circular(large ? 15 : 11),
        ),
        child: Icon(
          Icons.auto_stories_rounded,
          color: Colors.white,
          size: large ? 31 : 22,
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
