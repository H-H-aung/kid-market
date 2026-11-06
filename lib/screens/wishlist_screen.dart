import 'package:flutter/material.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/product_details_screen.dart';
import 'package:kids_mart/widgets/empty_state.dart';
import 'package:kids_mart/widgets/product_row.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final items = store.wishlistProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('My Wishlist')),
      body: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: EmptyState(
                Icons.favorite_border_rounded,
                'No favourites yet',
                'Tap a heart on a product to save it here.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => ProductRow(
                product: items[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(
                      product: items[i],
                      onAdd: (p) => saveAction(
                        context,
                        () => store.addToCart(p),
                        success: 'Added to cart',
                      ),
                    ),
                  ),
                ),
                onAdd: () => saveAction(
                  context,
                  () => store.addToCart(items[i]),
                  success: 'Added to cart',
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Add to cart',
                      onPressed: () => saveAction(
                        context,
                        () => store.addToCart(items[i]),
                        success: 'Added to cart',
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                    ),
                    IconButton(
                      tooltip: 'Remove favourite',
                      onPressed: () => saveAction(
                        context,
                        () => store.toggleFavourite(items[i]),
                      ),
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFFF6F91),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
