import 'package:flutter/material.dart';
import 'package:kids_mart/widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('My Orders')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        OrderCard('KM-1042', 'Preparing your order', .35, Color(0xFFFFE7A8)),
        SizedBox(height: 11),
        OrderCard('KM-1038', 'Delivered', 1, Color(0xFFD1F4E8)),
      ],
    ),
  );
}
