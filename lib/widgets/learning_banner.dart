import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/widgets/kid_art.dart';

class LearningBanner extends StatelessWidget {
  const LearningBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
    height: 150,
    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    padding: const EdgeInsets.fromLTRB(18, 18, 8, 14),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF1B9), Color(0xFFFFD8B5)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learn\nThrough Play',
                style: TextStyle(
                  color: blue,
                  fontSize: 21,
                  height: 1.02,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Explore educational products for every age.',
                style: TextStyle(color: ink, fontSize: 10),
              ),
              Spacer(),
              Text(
                'Start learning  →',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 115, child: KidArt(size: 115)),
      ],
    ),
  );
}
