import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/category.dart';
import 'package:jojo/models/product.dart';

class CategoryRow extends StatelessWidget {
  final List<Category> items;
  final List<Product> productItems;
  final ValueChanged<Category> onSelected;
  const CategoryRow({
    super.key,
    this.items = categories,
    this.productItems = products,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 280 ? 2 : 1;
        final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: CategoryTile(
                  item: item,
                  productCount: productItems
                      .where((p) => p.categoryId == item.id)
                      .length,
                  onTap: () => onSelected(item),
                ),
              ),
          ],
        );
      },
    ),
  );
}

class CategoryTile extends StatelessWidget {
  final Category item;
  final int productCount;
  final VoidCallback onTap;
  const CategoryTile({
    super.key,
    required this.item,
    required this.productCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Color.lerp(item.color, Colors.white, .55),
    borderRadius: BorderRadius.circular(24),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.icon, size: 30, color: ink),
                ),
                const Spacer(),
                const Icon(Icons.arrow_outward_rounded, size: 18, color: muted),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item.short,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: ink,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              productCount == 1
                  ? '1 item to explore'
                  : '$productCount items to explore',
              style: const TextStyle(color: muted, fontSize: 11, height: 1.4),
            ),
          ],
        ),
      ),
    ),
  );
}
