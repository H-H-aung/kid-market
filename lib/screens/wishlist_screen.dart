import 'package:flutter/material.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/widgets/product_row.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Wishlist')),
    body: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, i) => ProductRow(
        product: products[i],
        onTap: () {},
        onAdd: () {},
        trailing: const Icon(
          Icons.favorite_rounded,
          color: Color(0xFFFF6F91),
        ),
      ),
    ),
  );
}
