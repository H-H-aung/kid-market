import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/utils/money.dart';
import 'package:kids_mart/widgets/product_cover.dart';
import 'package:kids_mart/widgets/favourite_button.dart';

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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 165;
      final padding = compact ? 8.0 : 10.0;
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 20 : 24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ProductCover(product: product),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: FavouriteButton(product: product, compact: true),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filled(
                          onPressed: () => onAdd(product),
                          tooltip: 'Add ${product.title} to cart',
                          style: IconButton.styleFrom(
                            backgroundColor: ink.withValues(alpha: .88),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 19),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: compact ? 8 : 12),
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
                SizedBox(height: compact ? 6 : 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatMmk(product.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
