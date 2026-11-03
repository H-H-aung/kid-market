import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/widgets/lesson_tile.dart';
import 'package:jojo/widgets/progress_card.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 115),
      children: const [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learning Progress',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Keep going, Maya!',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFFFE4C9),
              child: Icon(Icons.face_rounded),
            ),
          ],
        ),
        SizedBox(height: 20),
        ProgressCard(),
        SizedBox(height: 22),
        Text(
          'Continue Learning',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 10),
        LessonTile(
          'Math Adventure',
          'Lesson 8 of 12',
          .67,
          Icons.calculate_rounded,
          Color(0xFFDCEEFF),
        ),
        LessonTile(
          'English Starter',
          'Lesson 5 of 10',
          .5,
          Icons.translate_rounded,
          Color(0xFFCFF4E8),
        ),
      ],
    );
  }
}
