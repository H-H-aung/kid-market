import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/screens/wishlist_screen.dart';
import 'package:kids_mart/widgets/home_header.dart';
import 'package:kids_mart/widgets/kid_avatar.dart';
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE6F2FF),
                    Color(0xFFF0EBFF),
                    Color(0xFFFFF4DF),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .8),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFD1E8FF),
                      child: KidAvatar(size: 74),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _email.isEmpty ? 'Add your name and email' : _email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: muted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _saving ? null : _editProfile,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: .85),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit profile'),
                  ),
                ],
              ),
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
                        subtitle: 'Track your orders',
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
                        subtitle: 'Your favourite finds',
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
