import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/screens/wishlist_screen.dart';
import 'package:kids_mart/widgets/home_header.dart';
import 'package:kids_mart/widgets/profile_tile.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/addresses_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String get _name => AppScope.of(context).name.isEmpty
      ? 'Welcome, Explorer'
      : AppScope.of(context).name;
  String get _email => AppScope.of(context).email;
  bool get _profileReady =>
      AppScope.of(context).name.isNotEmpty && _email.isNotEmpty;
  String get _initial => AppScope.of(context).name.isEmpty
      ? ''
      : AppScope.of(context).name.trimLeft()[0].toUpperCase();
  bool _saving = false;

  Future<void> _editProfile() async {
    var nextName = AppScope.of(context).name;
    var nextEmail = _email;
    final formKey = GlobalKey<FormState>();
    final result = await showModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: canvas,
      builder: (sheetContext) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit profile',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your details are saved on this device.',
                  style: TextStyle(color: muted, height: 1.4),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: AppScope.of(context).name,
                  onChanged: (value) => nextName = value,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter your name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _email,
                  onChanged: (value) => nextEmail = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ||
                          !RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(value.trim())
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(sheetContext, (
                          nextName.trim(),
                          nextEmail.trim(),
                        ));
                      }
                    },
                    child: const Text('Save changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (mounted && result != null) {
      setState(() => _saving = true);
      await saveAction(
        context,
        () => AppScope.of(context).saveProfile(result.$1, result.$2),
        success: 'Profile saved',
      );
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showHelp() {
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
                'A little help',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Explore by category',
                style: TextStyle(fontWeight: FontWeight.w700, color: ink),
              ),
              SizedBox(height: 6),
              Text(
                'Use Explore to browse books, courses, toys and flashcards. Tap a category to narrow your choices.',
                style: TextStyle(color: muted, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                'Your saved data',
                style: TextStyle(fontWeight: FontWeight.w700, color: ink),
              ),
              SizedBox(height: 6),
              Text(
                'Your profile, addresses, cart and favourites are saved on this device. Checkout records an order locally; it does not send it to a shop or collect payment.',
                style: TextStyle(color: muted, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
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
              'Your family’s learning corner.',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 22),
            _ProfileCard(
              name: _name,
              email: _email,
              initial: _initial,
              ready: _profileReady,
              saving: _saving,
              orderCount: AppScope.of(context).orders.length,
              wishlistCount: AppScope.of(context).wishlistProducts.length,
              addressCount: AppScope.of(context).addresses.length,
              onEdit: _editProfile,
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: width,
                      child: _ProfileShortcut(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        subtitle:
                            '${AppScope.of(context).orders.length} local orders',
                        color: const Color(0xFFDCEEFF),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrdersScreen(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: _ProfileShortcut(
                        icon: Icons.favorite_border_rounded,
                        title: 'My Wishlist',
                        subtitle:
                            '${AppScope.of(context).wishlistProducts.length} saved items',
                        color: const Color(0xFFFFE3EC),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WishlistScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            const Text(
              'Your account',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: ink,
              ),
            ),
            const SizedBox(height: 12),
            ProfileTile(
              Icons.location_on_outlined,
              'Saved addresses',
              const Color(0xFFE5F3ED),
              subtitle:
                  '${AppScope.of(context).addresses.length} saved addresses',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddressesScreen()),
              ),
            ),
            ProfileTile(
              Icons.help_outline_rounded,
              'Help & Support',
              const Color(0xFFFFF0D6),
              subtitle: 'A little guidance to get started',
              onTap: _showHelp,
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
                    'Discover books, courses, toys and flashcards for joyful learning. Your account details and saved items stay on this device.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'A little learning. A lot of possibility.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: muted),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ProfileCard extends StatelessWidget {
  final String name, email, initial;
  final bool ready, saving;
  final int orderCount, wishlistCount, addressCount;
  final VoidCallback onEdit;

  const _ProfileCard({
    required this.name,
    required this.email,
    required this.initial,
    required this.ready,
    required this.saving,
    required this.orderCount,
    required this.wishlistCount,
    required this.addressCount,
    required this.onEdit,
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
          right: -42,
          top: -55,
          child: _ProfileBubble(size: 150, color: Color(0x33FFFFFF)),
        ),
        const Positioned(
          left: -30,
          bottom: -65,
          child: _ProfileBubble(size: 120, color: Color(0x1FFFFFFF)),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .96),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: initial.isEmpty
                        ? const Icon(
                            Icons.person_rounded,
                            color: blue,
                            size: 34,
                          )
                        : Text(
                            initial,
                            style: const TextStyle(
                              color: blue,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email.isEmpty ? 'Add your name and email' : email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .16),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                ready
                                    ? Icons.verified_rounded
                                    : Icons.info_rounded,
                                color: const Color(0xFFFFD166),
                                size: 14,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  ready ? 'Profile ready' : 'Complete profile',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: saving ? null : onEdit,
                    tooltip: 'Edit profile',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: .17),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white54,
                    ),
                    icon: saving
                        ? const SizedBox.square(
                            dimension: 17,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.edit_rounded, size: 19),
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
                    _ProfileStat(value: orderCount, label: 'Orders'),
                    const _ProfileDivider(),
                    _ProfileStat(value: wishlistCount, label: 'Wishlist'),
                    const _ProfileDivider(),
                    _ProfileStat(value: addressCount, label: 'Addresses'),
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

class _ProfileStat extends StatelessWidget {
  final int value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

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

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: Colors.white24);
}

class _ProfileBubble extends StatelessWidget {
  final double size;
  final Color color;

  const _ProfileBubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

class _ProfileShortcut extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ProfileShortcut({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: ink, size: 23),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: ink,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: muted, height: 1.4),
            ),
          ],
        ),
      ),
    ),
  );
}
