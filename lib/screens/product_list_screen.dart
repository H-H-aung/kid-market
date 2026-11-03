import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/screens/product_details_screen.dart';
import 'package:jojo/widgets/mini_chip.dart';
import 'package:jojo/widgets/product_row.dart';

class ProductListScreen extends StatelessWidget {
  final String title;
  final ValueChanged<Product> onAdd;

  const ProductListScreen({
    super.key,
    required this.title,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                MiniChip('All'),
                SizedBox(width: 7),
                MiniChip('Story Books'),
                SizedBox(width: 7),
                MiniChip('Activity Books'),
                Spacer(),
                Icon(Icons.tune_rounded, size: 19, color: muted),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => ProductRow(
                product: products[i],
                onAdd: () => onAdd(products[i]),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(
                      product: products[i],
                      onAdd: onAdd,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
