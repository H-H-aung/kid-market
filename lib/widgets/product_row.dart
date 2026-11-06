import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/widgets/product_cover.dart';

class ProductRow extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final Widget? trailing;

  const ProductRow({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdd,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE4ECF4)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 92,
            child: ProductCover(product: product),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.age,
                  style: const TextStyle(
                    fontSize: 9,
                    color: blue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  product.title,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          trailing ??
              IconButton.filledTonal(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
              ),
        ],
      ),
    ),
  );
}
