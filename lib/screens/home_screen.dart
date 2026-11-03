import 'package:flutter/material.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/screens/product_details_screen.dart';
import 'package:jojo/widgets/category_widgets.dart';
import 'package:jojo/widgets/home_header.dart';
import 'package:jojo/widgets/learning_banner.dart';
import 'package:jojo/widgets/product_card.dart';
import 'package:jojo/widgets/search_box.dart';
import 'package:jojo/widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<Product> onAdd;
  const HomeScreen({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: HomeHeader()),
        const SliverToBoxAdapter(child: SearchBox()),
        const SliverToBoxAdapter(child: LearningBanner()),
        const SliverToBoxAdapter(child: SectionHeader('Categories')),
        const SliverToBoxAdapter(child: CategoryRow()),
        const SliverToBoxAdapter(child: SectionHeader('Popular Products')),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 218,
            child: ListView.separated(
              // This horizontal list needs its cards to use the full height.
              // A bottom inset here reduced every card and caused overflow.
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: 152,
                child: ProductCard(
                  product: products[i],
                  onAdd: onAdd,
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
          ),
        ),
      ],
    );
  }
}
