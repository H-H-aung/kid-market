import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF1688F8), Color(0xFF61C3FF)],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Weekly Goal',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacer(),
            Text(
              '72%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        SizedBox(height: 13),
        LinearProgressIndicator(
          value: .72,
          minHeight: 9,
          color: Color(0xFFFFD166),
          backgroundColor: Colors.white24,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        SizedBox(height: 10),
        Text(
          '3 of 5 learning days completed',
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
      ],
    ),
  );
}
