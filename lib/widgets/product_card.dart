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
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ProductCover(product: product),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.age,
              style: const TextStyle(
                fontSize: 11,
                color: muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 40 * MediaQuery.textScalerOf(context).scale(1),
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.3,
                  color: ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: ink,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () => onAdd(product),
                  tooltip: 'Add ${product.title} to cart',
                  style: IconButton.styleFrom(
                    backgroundColor: ink,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(44, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 21),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
