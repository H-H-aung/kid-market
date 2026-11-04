import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/widgets/product_grid.dart';
import 'package:jojo/widgets/empty_state.dart';

class ProductListScreen extends StatelessWidget {
  final String title;
  final ValueChanged<Product> onAdd;
  final String? categoryId;
  final List<Product> items;
  const ProductListScreen({
    super.key,
    required this.title,
    required this.onAdd,
    this.categoryId,
    this.items = products,
  });

  @override
  Widget build(BuildContext context) {
    final visibleItems = categoryId == null
        ? items
        : items.where((item) => item.categoryId == categoryId).toList();
    return Scaffold(
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
                    '${visibleItems.length} learning essentials to explore',
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          if (visibleItems.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: EmptyState(
                  Icons.auto_awesome_outlined,
                  'More discoveries soon',
                  'Please explore another category.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                24 + MediaQuery.paddingOf(context).bottom,
              ),
              sliver: ProductGrid(onAdd: onAdd, items: visibleItems),
            ),
        ],
      ),
    );
  }
}
