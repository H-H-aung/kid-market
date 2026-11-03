import 'package:flutter/material.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/screens/product_list_screen.dart';
import 'package:jojo/widgets/category_widgets.dart';

class ExploreScreen extends StatelessWidget {
  final ValueChanged<Product> onAdd;
  const ExploreScreen({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('Categories')),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 115),
          sliver: SliverGrid.builder(
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.02,
            ),
            itemBuilder: (_, i) => CategoryTile(
              item: categories[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    title: categories[i].title,
                    onAdd: onAdd,
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
