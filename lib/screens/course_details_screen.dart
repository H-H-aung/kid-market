import 'package:flutter/material.dart';
import 'package:jojo/models/course.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/widgets/info_box.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;
  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              color: course.color,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(course.icon, size: 92, color: blue),
          ),
          const SizedBox(height: 20),
          Text(
            course.title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text('Ms. Emma • ★ 4.9', style: TextStyle(color: muted)),
          const SizedBox(height: 18),
          Row(
            children: [
              InfoBox(Icons.child_care_rounded, course.age),
              const SizedBox(width: 8),
              const InfoBox(Icons.schedule_rounded, '6 weeks'),
              const SizedBox(width: 8),
              InfoBox(Icons.play_circle_outline, '${course.lessons} lessons'),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'What your child will learn',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          const Text(
            '✓ Build confidence with guided lessons\n✓ Practice through playful activities\n✓ Earn badges and track progress',
            style: TextStyle(color: muted, height: 1.8),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () {},
          child: const Text('Enroll Now'),
        ),
      ),
    );
  }
}
