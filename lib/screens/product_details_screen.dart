import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/widgets/mini_chip.dart';
import 'package:kids_mart/widgets/product_cover.dart';
import 'package:kids_mart/widgets/favourite_button.dart';
import 'package:kids_mart/data/app_store.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final ValueChanged<Product> onAdd;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product get product => widget.product;
  int _quantity = 1;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [FavouriteButton(product: product)]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
        children: [
          ProductCover(product: product, large: true),
          const SizedBox(height: 20),
          Text(
            product.title,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: ink,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                product.age,
                style: const TextStyle(
                  color: blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 23,
              color: ink,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Learning benefits',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniChip('Creativity'),
              MiniChip('Problem solving'),
              MiniChip('Early learning'),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Description',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(switch (product.categoryId) {
            'toys' =>
              'Build, play and explore with ${product.title}. A hands-on way to practise creativity and problem solving.',
            'courses' =>
              'Explore ${product.title} with playful learning activities for curious children.',
            'flashcards' =>
              'Practise new words and ideas together with ${product.title}.',
            _ =>
              'Discover ${product.title} and make reading part of your everyday learning adventures.',
          }, style: const TextStyle(color: muted, height: 1.55)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Decrease quantity',
                  onPressed: _quantity > 1 && !_saving
                      ? () => setState(() => _quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Increase quantity',
                  onPressed: _quantity < 99 && !_saving
                      ? () => setState(() => _quantity++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving
                    ? null
                    : () async {
                        final store = AppScope.maybeOf(context);
                        if (store == null) {
                          for (var i = 0; i < _quantity; i++) {
                            widget.onAdd(product);
                          }
                          return;
                        }
                        setState(() => _saving = true);
                        await saveAction(
                          context,
                          () => store.addToCart(product, quantity: _quantity),
                          success: 'Added to cart',
                        );
                        if (mounted) setState(() => _saving = false);
                      },
                child: Text(_saving ? 'Saving...' : 'Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
