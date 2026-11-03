import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/models/product.dart';
import 'package:jojo/widgets/product_cover.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final ValueChanged<Product> onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(17),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE4ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ProductCover(product: product)),
          const SizedBox(height: 8),
          Text(
            product.age,
            style: const TextStyle(
              fontSize: 8.5,
              color: blue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFB703), size: 14),
              const Text(' 4.8', style: TextStyle(fontSize: 9, color: muted)),
              const Spacer(),
              IconButton.filled(
                onPressed: () => onAdd(product),
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add_rounded, size: 18),
              ),
            ],
          ),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: ink,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    ),
  );
}
