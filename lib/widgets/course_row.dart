import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/screens/course_details_screen.dart';

class CourseRow extends StatelessWidget {
  const CourseRow({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 150,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: courses.length,
      separatorBuilder: (_, _) => const SizedBox(width: 10),
      itemBuilder: (_, i) => InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailsScreen(course: courses[i]),
          ),
        ),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: courses[i].color,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Icon(courses[i].icon, color: blue),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_outward_rounded, size: 18),
                ],
              ),
              const Spacer(),
              Text(
                courses[i].title,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 3),
              Text(
                '${courses[i].lessons} lessons • ${courses[i].age}',
                style: const TextStyle(fontSize: 10, color: muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
