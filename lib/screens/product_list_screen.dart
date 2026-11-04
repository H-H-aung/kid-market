import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/widgets/product_grid.dart';

class ProductListScreen extends StatelessWidget {
  final String title;
  final ValueChanged<Product> onAdd;
  const ProductListScreen({
    super.key,
    required this.title,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Little discoveries, big possibilities.',
                  style: TextStyle(
                    color: ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${products.length} learning essentials to explore',
                  style: const TextStyle(color: muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            24 + MediaQuery.paddingOf(context).bottom,
          ),
          sliver: ProductGrid(onAdd: onAdd),
        ),
      ],
    ),
  );
}
