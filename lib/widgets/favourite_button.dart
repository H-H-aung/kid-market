import 'package:flutter/material.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/models/product.dart';

class FavouriteButton extends StatelessWidget {
  final Product product;
  const FavouriteButton({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    final store = AppScope.maybeOf(context);
    if (store == null) return const SizedBox.shrink();
    final selected = store.isFavourite(product);
    return IconButton(
      tooltip: selected ? 'Remove favourite' : 'Save favourite',
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: .9),
      ),
      onPressed: () =>
          saveAction(context, () => store.toggleFavourite(product)),
      icon: Icon(
        selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: selected ? const Color(0xFFE45F82) : const Color(0xFF21314A),
      ),
    );
  }
}
