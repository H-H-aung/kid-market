import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/widgets/mini_chip.dart';
import 'package:kids_mart/widgets/product_cover.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  final ValueChanged<Product> onAdd;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.favorite_border_rounded),
          ),
        ],
      ),
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
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFB700),
                size: 19,
              ),
              const Text(' 4.9  (128 reviews)', style: TextStyle(color: muted)),
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
          const Text(
            'A collection of short and sweet stories to help kids relax, learn and dream big.',
            style: TextStyle(color: muted, height: 1.55),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.remove), Text('  1  '), Icon(Icons.add)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => onAdd(product),
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
