import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/models/category.dart';
import 'package:kids_mart/models/product.dart';

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
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final width =
            ((constraints.maxWidth - 30) / 4).clamp(84.0, 110.0) * scale;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in items)
                Padding(
                  padding: EdgeInsets.only(right: item == items.last ? 0 : 10),
                  child: SizedBox(
                    width: width,
                    child: CategoryTile(
                      item: item,
                      productCount: productItems
                          .where((p) => p.categoryId == item.id)
                          .length,
                      onTap: () => onSelected(item),
                    ),
                  ),
                ),
            ],
          ),
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
    borderRadius: BorderRadius.circular(18),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(item.icon, size: 26, color: ink),
            ),
            const SizedBox(height: 8),
            Text(
              item.short,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: ink,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              productCount == 1 ? '1 item' : '$productCount items',
              style: const TextStyle(color: muted, fontSize: 10, height: 1.4),
            ),
          ],
        ),
      ),
    ),
  );
}
