import 'package:flutter/material.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/product_list_screen.dart';
import 'package:kids_mart/widgets/category_widgets.dart';
import 'package:kids_mart/widgets/home_header.dart';
import 'package:kids_mart/widgets/learning_banner.dart';
import 'package:kids_mart/widgets/product_grid.dart';
import 'package:kids_mart/widgets/search_box.dart';
import 'package:kids_mart/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<Product> onAdd;
  const HomeScreen({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      const SliverToBoxAdapter(child: HomeHeader()),
      const SliverToBoxAdapter(child: SearchBox()),
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
              builder: (_) =>
                  ProductListScreen(title: 'Popular Products', onAdd: onAdd),
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 130),
        sliver: ProductGrid(onAdd: onAdd),
      ),
    ],
  );
}
