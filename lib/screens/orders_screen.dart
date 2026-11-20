import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/utils/money.dart';
import 'package:kids_mart/screens/addresses_screen.dart';
import 'package:kids_mart/screens/profile_screen.dart';
import 'package:kids_mart/widgets/empty_state.dart';

class OrdersScreen extends StatefulWidget {
  final String? orderId;
  const OrdersScreen({super.key, this.orderId});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _orderNotifications = true;
  bool _deliveryUpdates = true;

  void _showMenuSheet(String title) {
    if (title == 'Settings') {
      _showSettings();
      return;
    }
    const details = <String, List<String>>{
      'Contact Us': [
        'Have your order number ready so we can help faster.',
        'Include the item name and a short description of the issue.',
        'For delivery questions, use the same phone number entered at checkout.',
      ],
      'Help Center': [
        'Browse products, add them to Cart, then continue as a guest.',
        'Your delivery details are only requested during checkout.',
        'Recent orders stay available on this device under My Orders.',
      ],
      'Shipping & Delivery': [
        'Delivery details are confirmed when an order is placed.',
        'Use your order number to check an order status.',
        'Keep your delivery phone number accurate for verification.',
      ],
      'Returns & Refunds': [
        'Keep your order number and item details before requesting help.',
        'Return eligibility and refund timing depend on the seller policy.',
        'Choose Contact Us if you need help with a recent order.',
      ],
      'About Us': [
        'Kids Mart brings learning, play and family essentials together.',
        'You can browse and checkout as a guest—no customer account needed.',
        'Your cart and recent order references are kept on this device.',
      ],
    };
    final detailLines = details[title] ?? const <String>[];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final horizontalPadding = (MediaQuery.sizeOf(context).width * .06)
            .clamp(16.0, 40.0)
            .toDouble();
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              8,
              horizontalPadding,
              32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                for (final line in detailLines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 18,
                            color: blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSettings() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final horizontalPadding = (MediaQuery.sizeOf(context).width * .06)
              .clamp(16.0, 40.0)
              .toDouble();
          return FractionallySizedBox(
            heightFactor: .82,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  24 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose how you want to receive updates about your guest orders.',
                      style: TextStyle(color: muted),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.notifications_outlined),
                      title: const Text('Order notifications'),
                      subtitle: const Text('Updates when an order is saved'),
                      value: _orderNotifications,
                      onChanged: (value) {
                        setState(() => _orderNotifications = value);
                        setSheetState(() {});
                      },
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.local_shipping_outlined),
                      title: const Text('Delivery updates'),
                      subtitle: const Text(
                        'Keep delivery status updates visible',
                      ),
                      value: _deliveryUpdates,
                      onChanged: (value) {
                        setState(() => _deliveryUpdates = value);
                        setSheetState(() {});
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person_outline_rounded),
                      title: const Text('Profile'),
                      subtitle: const Text('Manage your account details'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          Navigator.of(this.context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        });
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_on_outlined),
                      title: const Text('Delivery addresses'),
                      subtitle: const Text(
                        'Add, edit or choose an address for checkout',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          Navigator.of(this.context).push(
                            MaterialPageRoute(
                              builder: (_) => const AddressesScreen(),
                            ),
                          );
                        });
                      },
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.lock_outline),
                      title: Text('Order privacy'),
                      subtitle: Text(
                        'Order details require the order number and delivery-phone verification.',
                      ),
                    ),
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.info_outline),
                      title: Text('Kids Mart'),
                      subtitle: Text('Guest checkout · Version 1.0.0'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final orders = widget.orderId == null
        ? store.orders
        : store.orders.where((order) => order.id == widget.orderId).toList();
    return Scaffold(
      backgroundColor: canvas,
      appBar: AppBar(
        title: Text(widget.orderId == null ? 'My Orders' : 'Order details'),
        backgroundColor: canvas,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'More options',
            onSelected: _showMenuSheet,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Settings', child: Text('Settings')),
              PopupMenuItem(value: 'Contact Us', child: Text('Contact Us')),
              PopupMenuItem(value: 'Help Center', child: Text('Help Center')),
              PopupMenuItem(
                value: 'Shipping & Delivery',
                child: Text('Shipping & Delivery'),
              ),
              PopupMenuItem(
                value: 'Returns & Refunds',
                child: Text('Returns & Refunds'),
              ),
              PopupMenuItem(value: 'About Us', child: Text('About Us')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 128),
        children: [
          Text('Order History', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('Orders placed as a guest on this device.'),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: EmptyState(
                Icons.inventory_2_outlined,
                'No orders yet',
                'Your guest orders will appear here after checkout.',
              ),
            )
          else
            for (final order in orders) _OrderDetailsCard(order: order),
        ],
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  final SavedOrder order;
  const _OrderDetailsCard({required this.order});
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ExpansionTile(
      key: PageStorageKey(order.id),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFEAF4FF),
        child: Icon(Icons.inventory_2_outlined, color: blue),
      ),
      title: Text(
        order.id,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        '${MaterialLocalizations.of(context).formatMediumDate(order.createdAt)} · Order Status: Saved',
      ),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Order Details',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 10),
        for (final line in order.lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(child: Text('${line.title} × ${line.quantity}')),
                Text(formatMmkCents(line.totalCents)),
              ],
            ),
          ),
        const Divider(),
        Text(
          'Delivery to\n${order.address.summary}',
          style: const TextStyle(height: 1.45),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Total: ${formatMmkCents(order.totalCents)}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}
