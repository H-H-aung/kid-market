import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/models/product.dart';
import 'package:kids_mart/screens/addresses_screen.dart';
import 'package:kids_mart/screens/auth_screen.dart';
import 'package:kids_mart/screens/order_success_screen.dart';
import 'package:kids_mart/screens/product_details_screen.dart';
import 'package:kids_mart/widgets/price_line.dart';
import 'package:kids_mart/widgets/product_cover.dart';
import 'package:kids_mart/utils/money.dart';

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
    if (!store.isSignedIn) {
      final signedIn = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
      if (signedIn != true || !mounted) return;
    }
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
          'Total: ${formatMmkCents(store.totalCents)}\n\nThis records the order on this device only. It will not be sent to a shop and no payment will be collected.',
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
      backgroundColor: canvas,
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: canvas,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 150),
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
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Your bag',
                    style: TextStyle(
                      color: ink,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${store.cartCount} ${store.cartCount == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      color: blue,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final product in items)
              Card(
                elevation: 0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: ink.withValues(alpha: .05)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
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
                            child: InkWell(
                              onTap: () => Navigator.push(
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
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: ink,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      formatMmkCents((product.price * 100).round()),
                                      style: const TextStyle(color: muted),
                                    ),
                                  ],
                                ),
                              ),
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _QuantityControl(
                            label: '${store.cart[product.id]}',
                            onDecrease: !_busy && store.cart[product.id]! > 1
                                ? () => _change(() => store.setQuantity(product, store.cart[product.id]! - 1))
                                : null,
                            onIncrease: !_busy && store.cart[product.id]! < 99
                                ? () => _change(() => store.setQuantity(product, store.cart[product.id]! + 1))
                                : null,
                          ),
                          const Spacer(),
                          Text(
                            formatMmkCents(
                              (product.price * 100).round() *
                                  store.cart[product.id]!,
                            ),
                            style: const TextStyle(
                              color: ink,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            const SizedBox(height: 8),
            const Text('DELIVERY ADDRESS', style: _sectionStyle),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      store.defaultAddress?.summary ?? 'Add an address to continue.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F3FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  PriceLine('Subtotal', formatMmkCents(store.totalCents)),
                  const PriceLine('Delivery', 'Free'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: blue.withValues(alpha: .2)),
                  ),
                  PriceLine('Total', formatMmkCents(store.totalCents), strong: true),
                ],
              ),
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

const _sectionStyle = TextStyle(
  color: muted,
  fontSize: 11,
  fontWeight: FontWeight.w900,
  letterSpacing: 1.1,
);

class _QuantityControl extends StatelessWidget {
  final String label;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  const _QuantityControl({
    required this.label,
    this.onDecrease,
    this.onIncrease,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF0F6FF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: onDecrease, icon: const Icon(Icons.remove, size: 18)),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        IconButton(onPressed: onIncrease, icon: const Icon(Icons.add, size: 18)),
      ],
    ),
  );
}
