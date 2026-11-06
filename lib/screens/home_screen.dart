import 'package:flutter/material.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/product_list_screen.dart';
import 'package:kids_mart/widgets/category_widgets.dart';
import 'package:kids_mart/widgets/home_header.dart';
import 'package:kids_mart/widgets/learning_banner.dart';
import 'package:kids_mart/widgets/product_grid.dart';
import 'package:kids_mart/widgets/search_box.dart';
import 'package:kids_mart/widgets/section_header.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<Product> onAdd;
  const HomeScreen({super.key, required this.onAdd});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueChanged<Product> get onAdd => widget.onAdd;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final items = products
        .where(
          (p) =>
              p.title.toLowerCase().contains(_query) ||
              p.categoryId.contains(_query),
        )
        .toList();
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: HomeHeader()),
        SliverToBoxAdapter(
          child: SearchBox(
            onChanged: (value) =>
                setState(() => _query = value.trim().toLowerCase()),
          ),
        ),
        if (_query.isEmpty) ...[
          const SliverToBoxAdapter(child: LearningBanner()),
          const SliverToBoxAdapter(child: SectionHeader('Categories')),
          SliverToBoxAdapter(
            child: CategoryRow(
              onSelected: (category) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: category.title,
                    categoryId: category.id,
                    onAdd: onAdd,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              'Popular finds',
              onSeeAll: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: 'Popular Products',
                    onAdd: onAdd,
                  ),
                ),
              ),
            ),
          ),
        ] else
          const SliverToBoxAdapter(child: SectionHeader('Search results')),
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
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
            sliver: ProductGrid(onAdd: onAdd, items: items),
          ),
      ],
    );
  }
}
