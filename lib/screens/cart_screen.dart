import 'package:flutter/material.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/addresses_screen.dart';
import 'package:kids_mart/screens/order_success_screen.dart';
import 'package:kids_mart/screens/product_details_screen.dart';
import 'package:kids_mart/widgets/price_line.dart';
import 'package:kids_mart/widgets/product_cover.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onContinueShopping;
  const CartScreen({super.key, required this.onContinueShopping});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _busy = false;
  Future<void> _change(Future<void> Function() action) async {
    setState(() => _busy = true);
    await saveAction(context, action);
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _checkout() async {
    if (_busy) return;
    final store = AppScope.of(context);
    if (store.defaultAddress == null) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddressesScreen()),
      );
      return;
    }
    setState(() => _busy = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save this order?'),
        content: Text(
          'Total: \$${(store.totalCents / 100).toStringAsFixed(2)}\n\nThis records the order on this device only. It will not be sent to a shop and no payment will be collected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save order'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      try {
        final order = await store.checkout();
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              order: order,
              onContinueShopping: widget.onContinueShopping,
            ),
          ),
        );
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Order could not be saved. Your cart has been kept. Please try again.',
              ),
            ),
          );
        }
      }
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final items = store.cartProducts;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 150),
        children: [
          if (items.isEmpty) ...[
            const SizedBox(height: 50),
            const Icon(Icons.shopping_bag_outlined, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: widget.onContinueShopping,
              child: const Text('Continue shopping'),
            ),
          ] else ...[
            for (final product in items)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 68,
                            height: 78,
                            child: ProductCover(product: product),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                    product: product,
                                    onAdd: (Product p) => saveAction(
                                      context,
                                      () => store.addToCart(p),
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(product.title),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove ${product.title}',
                            onPressed: _busy
                                ? null
                                : () => _change(
                                    () => store.setQuantity(product, 0),
                                  ),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          IconButton(
                            tooltip: 'Decrease ${product.title}',
                            onPressed: !_busy && store.cart[product.id]! > 1
                                ? () => _change(
                                    () => store.setQuantity(
                                      product,
                                      store.cart[product.id]! - 1,
                                    ),
                                  )
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${store.cart[product.id]}'),
                          IconButton(
                            tooltip: 'Increase ${product.title}',
                            onPressed: !_busy && store.cart[product.id]! < 99
                                ? () => _change(
                                    () => store.setQuantity(
                                      product,
                                      store.cart[product.id]! + 1,
                                    ),
                                  )
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                          Text(
                            '\$${((product.price * 100).round() * store.cart[product.id]! / 100).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Delivery address',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              store.defaultAddress?.summary ?? 'Add an address to continue.',
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _busy
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddressesScreen(),
                        ),
                      ),
                child: Text(
                  store.defaultAddress == null
                      ? 'Add delivery address'
                      : 'Change address',
                ),
              ),
            ),
            const Divider(height: 32),
            PriceLine(
              'Subtotal',
              '\$${(store.totalCents / 100).toStringAsFixed(2)}',
            ),
            const PriceLine('Delivery', 'Free'),
            const SizedBox(height: 12),
            PriceLine(
              'Total',
              '\$${(store.totalCents / 100).toStringAsFixed(2)}',
              strong: true,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _checkout,
              child: Text(_busy ? 'Saving...' : 'Review order'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Orders are saved on this device. No payment is collected.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
