import 'package:flutter/material.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/screens/product_list_screen.dart';
import 'package:jojo/widgets/category_widgets.dart';
import 'package:jojo/widgets/home_header.dart';
import 'package:jojo/widgets/learning_banner.dart';
import 'package:jojo/widgets/product_grid.dart';
import 'package:jojo/widgets/search_box.dart';
import 'package:jojo/widgets/section_header.dart';

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
      const SliverToBoxAdapter(child: CategoryRow()),
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
