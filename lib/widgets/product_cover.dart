import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/models/product.dart';

class ProductCover extends StatelessWidget {
  final Product product;
  final bool large;
  const ProductCover({super.key, required this.product, this.large = false});

  @override
  Widget build(BuildContext context) => Container(
    height: large ? 270 : null,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.lerp(product.color, Colors.white, .35)!, product.color],
      ),
      borderRadius: BorderRadius.circular(large ? 26 : 18),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -size * .2,
              top: -size * .2,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .25),
                ),
              ),
            ),
            Positioned(
              left: size * .08,
              bottom: size * .12,
              child: Icon(
                Icons.auto_awesome,
                size: size * .15,
                color: Colors.white.withValues(alpha: .85),
              ),
            ),
            Transform.rotate(
              angle: -.10,
              child: Container(
                width: size * .57,
                height: size * .73,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size * .07),
                  boxShadow: [
                    BoxShadow(
                      color: ink.withValues(alpha: .13),
                      blurRadius: 16,
                      offset: const Offset(5, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: size * .035,
                      decoration: BoxDecoration(
                        color: blue.withValues(alpha: .15),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(size * .07),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(product.icon, color: blue, size: size * .30),
                          SizedBox(height: size * .07),
                          Container(
                            width: size * .28,
                            height: size * .025,
                            decoration: BoxDecoration(
                              color: product.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: size * .035),
                          Container(
                            width: size * .18,
                            height: size * .025,
                            decoration: BoxDecoration(
                              color: product.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
