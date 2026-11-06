import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/widgets/category_widgets.dart';
import 'package:kids_mart/widgets/home_header.dart';
import 'package:kids_mart/widgets/product_grid.dart';
import 'package:kids_mart/widgets/search_box.dart';
import 'package:kids_mart/widgets/empty_state.dart';

class ExploreScreen extends StatefulWidget {
  final ValueChanged<Product> onAdd;
  const ExploreScreen({super.key, required this.onAdd});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String? _categoryId;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final selected = categories
        .where((category) => category.id == _categoryId)
        .firstOrNull;
    final items = products
        .where(
          (product) =>
              (_categoryId == null || product.categoryId == _categoryId) &&
              (product.title.toLowerCase().contains(_query) ||
                  product.categoryId.contains(_query)),
        )
        .toList();
    return CustomScrollView(
      key: const PageStorageKey('explore'),
      slivers: [
        const SliverToBoxAdapter(child: HomeHeader()),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find their next favourite',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Little things for big imaginations.',
                  style: TextStyle(fontSize: 13, color: muted),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: CategoryRow(
            selectedId: _categoryId,
            onSelected: (category) => setState(() => _categoryId = category.id),
          ),
        ),
        SliverToBoxAdapter(
          child: SearchBox(
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase()),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected?.title ?? 'All discoveries',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${items.length} items to explore',
                        style: const TextStyle(fontSize: 12, color: muted),
                      ),
                    ],
                  ),
                ),
                if (_categoryId != null)
                  TextButton.icon(
                    onPressed: () => setState(() => _categoryId = null),
                    icon: const Icon(Icons.apps_rounded, size: 16),
                    label: const Text('View all'),
                  ),
              ],
            ),
          ),
        ),
        if (items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: EmptyState(
                Icons.search_off_rounded,
                'No products found',
                'Try another name or category.',
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
            sliver: ProductGrid(onAdd: widget.onAdd, items: items),
          ),
      ],
    );
  }
}
