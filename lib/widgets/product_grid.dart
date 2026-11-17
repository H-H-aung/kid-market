import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/product_details_screen.dart';
import 'package:kids_mart/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final ValueChanged<Product> onAdd;
  final List<Product> items;
  const ProductGrid({super.key, required this.onAdd, this.items = products});

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = MediaQuery.sizeOf(context).width;
      final compact = screenWidth < 360;
      final cardWidth = compact ? 150.0 : 170.0;
      final columns = math.max(
        1,
        (constraints.crossAxisExtent / cardWidth).floor(),
      );
      final textScale = MediaQuery.textScalerOf(context).scale(1);
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: compact ? 10 : 14,
          crossAxisSpacing: compact ? 10 : 14,
          mainAxisExtent:
              (compact ? 278 : 292) + math.max(0, textScale - 1) * 110,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => ProductCard(
            product: items[i],
            onAdd: onAdd,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailsScreen(product: items[i], onAdd: onAdd),
              ),
            ),
          ),
          childCount: items.length,
        ),
      );
    },
  );
}
