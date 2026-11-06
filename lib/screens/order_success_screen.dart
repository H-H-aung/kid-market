import 'package:flutter/material.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final SavedOrder order;
  final VoidCallback onContinueShopping;
  const OrderSuccessScreen({
    super.key,
    required this.order,
    required this.onContinueShopping,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Order saved')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
          const SizedBox(height: 24),
          const Text(
            'Your order has been saved',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(order.id, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Total: \$${(order.totalCents / 100).toStringAsFixed(2)}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Saved on this device only. It has not been sent to a shop and no payment has been collected.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              onContinueShopping();
              Navigator.pop(context);
            },
            child: const Text('Continue Shopping'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
            child: const Text('View orders'),
          ),
        ],
      ),
    ),
  );
}
