import 'package:flutter/material.dart';
import 'package:jojo/constants/colors.dart';
import 'package:jojo/models/product.dart';

class ProductCover extends StatelessWidget {
  final Product product;
  final bool large;
  const ProductCover({super.key, required this.product, this.large = false});

  @override
  Widget build(BuildContext context) => Container(
    height: large ? 270 : null,
    decoration: BoxDecoration(
      color: product.color,
      borderRadius: BorderRadius.circular(large ? 22 : 13),
    ),
    child: Center(
      child: Container(
        width: large ? 155 : 75,
        height: large ? 205 : 92,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .10),
              blurRadius: 9,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: large ? 82 : 43,
              height: large ? 82 : 43,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF5FF),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(product.icon, color: blue, size: large ? 54 : 28),
                  Positioned(
                    right: large ? 7 : 3,
                    top: large ? 6 : 3,
                    child: Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFFB703),
                      size: large ? 20 : 11,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: large ? 13 : 6),
            Text(
              product.title.toUpperCase(),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: large ? 12 : 6.5,
                fontWeight: FontWeight.w900,
                color: ink,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
