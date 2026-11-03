import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/category.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 88,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(width: 14),
      itemBuilder: (_, i) => SizedBox(
        width: 58,
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: categories[i].color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .84),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(categories[i].icon, size: 21, color: blue),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              categories[i].short,
              maxLines: 1,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    ),
  );
}

class CategoryTile extends StatelessWidget {
  final Category item;
  final VoidCallback onTap;
  const CategoryTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4ECF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A789D).withValues(alpha: .06),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .84),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: blue, size: 24),
              ),
            ),
          ),
          const Spacer(),
          Text(
            item.title,
            maxLines: 2,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          const Text(
            '12 resources',
            style: TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
    ),
  );
}
