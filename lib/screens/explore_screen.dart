import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/screens/product_list_screen.dart';
import 'package:jojo/widgets/category_widgets.dart';

class ExploreScreen extends StatelessWidget {
  final ValueChanged<Product> onAdd;
  const ExploreScreen({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      const SliverAppBar(title: Text('Categories')),
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Text(
            'What will they discover today?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
        ),
      ),
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
      const SliverToBoxAdapter(child: SizedBox(height: 140)),
    ],
  );
}
