import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/screens/product_details_screen.dart';
import 'package:jojo/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final ValueChanged<Product> onAdd;
  const ProductGrid({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final columns = math.max(1, (constraints.crossAxisExtent / 170).floor());
      final textScale = MediaQuery.textScalerOf(context).scale(1);
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          mainAxisExtent: 292 + math.max(0, textScale - 1) * 110,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => ProductCard(
            product: products[i],
            onAdd: onAdd,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailsScreen(product: products[i], onAdd: onAdd),
              ),
            ),
          ),
          childCount: products.length,
        ),
      );
    },
  );
}
