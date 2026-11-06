import 'package:flutter/material.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/widgets/empty_state.dart';

class OrdersScreen extends StatelessWidget {
  final String? orderId;
  const OrdersScreen({super.key, this.orderId});
  @override
  Widget build(BuildContext context) {
    final orders = AppScope.of(
      context,
    ).orders.where((order) => orderId == null || order.id == orderId).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(orderId == null ? 'My Orders' : 'Order details'),
      ),
      body: orders.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: EmptyState(
                Icons.receipt_long_outlined,
                'No orders yet',
                'Orders you save at checkout will appear here.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: ExpansionTile(
                    key: PageStorageKey(order.id),
                    initiallyExpanded: orderId != null,
                    tilePadding: const EdgeInsets.all(16),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    title: Text(
                      order.id,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${MaterialLocalizations.of(context).formatMediumDate(order.createdAt)}\nSaved on this device - not sent to a shop',
                      style: const TextStyle(height: 1.5),
                    ),
                    children: [
                      for (final line in order.lines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('${line.title} × ${line.quantity}'),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${(line.totalCents / 100).toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                      const Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: \$${(order.totalCents / 100).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(order.address.summary),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
