import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/addresses_screen.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/screens/wishlist_screen.dart';
import 'package:kids_mart/widgets/home_header.dart';
import 'package:kids_mart/widgets/profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: canvas,
      builder: (context) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How it works',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              SizedBox(height: 20),
              _HelpStep(
                number: '1',
                title: 'Shop without signing in',
                body: 'Browse products, save favourites and build your cart.',
              ),
              _HelpStep(
                number: '2',
                title: 'Add details at checkout',
                body:
                    'Recipient, phone and delivery address are requested only when you place an order.',
              ),
              _HelpStep(
                number: '3',
                title: 'Keep your order number',
                body:
                    'After checkout, use the KM order number in Order tracking to find the saved order.',
              ),
              SizedBox(height: 8),
              Text(
                'Demo note: orders are currently saved on this device only. No payment is collected or sent to a shop.',
                style: TextStyle(color: muted, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final latestOrder = store.orders.firstOrNull;
    return ListView(
      padding: const EdgeInsets.only(bottom: 140),
      children: [
        const HomeHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'No sign-in needed. Your details are requested at checkout.',
                style: TextStyle(fontSize: 13, color: muted, height: 1.4),
              ),
              const SizedBox(height: 22),
              _GuestActivityCard(
                orderCount: store.orders.length,
                wishlistCount: store.wishlistProducts.length,
                cartCount: store.cartCount,
              ),
              const SizedBox(height: 24),
              const Text(
                'Shopping activity',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              const SizedBox(height: 12),
              ProfileTile(
                Icons.local_shipping_outlined,
                'Order tracking',
                const Color(0xFFDCEEFF),
                subtitle: latestOrder == null
                    ? 'Your order number appears after checkout'
                    : 'Latest order: ${latestOrder.id}',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersScreen()),
                ),
              ),
              ProfileTile(
                Icons.favorite_border_rounded,
                'My Wishlist',
                const Color(0xFFFFE3EC),
                subtitle: '${store.wishlistProducts.length} saved items',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WishlistScreen()),
                ),
              ),
              ProfileTile(
                Icons.location_on_outlined,
                'Delivery details',
                const Color(0xFFE5F3ED),
                subtitle: store.addresses.isEmpty
                    ? 'Add them now or during checkout'
                    : '${store.addresses.length} saved addresses',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressesScreen()),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'More',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              const SizedBox(height: 12),
              ProfileTile(
                Icons.help_outline_rounded,
                'How it works',
                const Color(0xFFFFF0D6),
                subtitle: 'Shopping and checkout in three steps',
                onTap: () => _showHelp(context),
              ),
              ProfileTile(
                Icons.info_outline_rounded,
                'About Kids Mart',
                const Color(0xFFEDE8FF),
                subtitle: 'Made for curious little minds',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Kids Mart',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.auto_stories_rounded,
                    color: blue,
                    size: 36,
                  ),
                  children: const [
                    Text(
                      'Discover books, courses, toys and flashcards for joyful learning. Saved activity stays on this device.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GuestActivityCard extends StatelessWidget {
  final int orderCount, wishlistCount, cartCount;

  const _GuestActivityCard({
    required this.orderCount,
    required this.wishlistCount,
    required this.cartCount,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1688F8), Color(0xFF6378EA)],
      ),
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: blue.withValues(alpha: .18),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Stack(
      children: [
        const Positioned(
          right: -40,
          top: -50,
          child: _Bubble(size: 145, color: Color(0x2EFFFFFF)),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: blue,
                      size: 29,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guest shopping',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your activity stays on this device.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'LOCAL',
                      style: TextStyle(
                        color: Color(0xFFFFD166),
                        fontSize: 9,
                        letterSpacing: .8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    _ActivityStat(value: orderCount, label: 'Orders'),
                    const _StatDivider(),
                    _ActivityStat(value: wishlistCount, label: 'Wishlist'),
                    const _StatDivider(),
                    _ActivityStat(value: cartCount, label: 'In cart'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ActivityStat extends StatelessWidget {
  final int value;
  final String label;

  const _ActivityStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: Colors.white24);
}

class _Bubble extends StatelessWidget {
  final double size;
  final Color color;

  const _Bubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _HelpStep extends StatelessWidget {
  final String number, title, body;

  const _HelpStep({
    required this.number,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: const Color(0xFFDCEEFF),
          child: Text(
            number,
            style: const TextStyle(color: blue, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, color: ink),
              ),
              const SizedBox(height: 4),
              Text(body, style: const TextStyle(color: muted, height: 1.45)),
            ],
          ),
        ),
      ],
    ),
  );
}
