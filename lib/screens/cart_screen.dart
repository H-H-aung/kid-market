import 'package:flutter/material.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/order_success_screen.dart';
import 'package:kids_mart/widgets/empty_state.dart';
import 'package:kids_mart/widgets/price_line.dart';
import 'package:kids_mart/widgets/product_row.dart';

class CartScreen extends StatelessWidget {
  final List<Product> items;
  final ValueChanged<int> onRemove;
  final VoidCallback onContinueShopping;

  const CartScreen({
    super.key,
    required this.items,
    required this.onRemove,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (sum, e) => sum + e.price);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.transparent,
      ),
      body: items.isEmpty
          ? const EmptyState(
              Icons.shopping_bag_outlined,
              'Your cart is empty',
              'Add learning products to get started.',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => ProductRow(
                      product: items[i],
                      onTap: () {},
                      onAdd: () {},
                      trailing: IconButton(
                        onPressed: () => onRemove(i),
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 105),
                  color: Colors.white,
                  child: Column(
                    children: [
                      PriceLine('Subtotal', '\$${total.toStringAsFixed(2)}'),
                      const PriceLine('Delivery', 'Free'),
                      const Divider(height: 22),
                      PriceLine(
                        'Total',
                        '\$${total.toStringAsFixed(2)}',
                        strong: true,
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderSuccessScreen(
                                onContinueShopping: onContinueShopping,
                              ),
                            ),
                          ),
                          child: const Text('Proceed (No Payment)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
