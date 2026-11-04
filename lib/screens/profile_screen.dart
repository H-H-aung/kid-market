import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/screens/wishlist_screen.dart';
import 'package:kids_mart/widgets/kid_avatar.dart';
import 'package:kids_mart/widgets/profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ListView(
        padding: const EdgeInsets.fromLTRB(22, 30, 22, 105),
        children: [
          const Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 39,
                  backgroundColor: Color(0xFF8ED9F7),
                  child: KidAvatar(size: 70),
                ),
                SizedBox(height: 12),
                Text(
                  'Little Explorer',
                  style: TextStyle(
                    color: ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'little.explorer@email.com',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 29),
          ProfileTile(
            Icons.shopping_bag_outlined,
            'My Orders',
            Colors.transparent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersScreen()),
            ),
          ),
          ProfileTile(
            Icons.favorite_border_rounded,
            'My Wishlist',
            Colors.transparent,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishlistScreen()),
            ),
          ),
          const ProfileTile(
            Icons.location_on_outlined,
            'Addresses',
            Colors.transparent,
          ),
          const ProfileTile(
            Icons.help_outline_rounded,
            'Help & Support',
            Colors.transparent,
          ),
          const ProfileTile(
            Icons.info_outline_rounded,
            'About App',
            Colors.transparent,
          ),
        ],
      ),
      const Positioned(
        right: 18,
        top: 18,
        child: Icon(Icons.settings_outlined, color: ink, size: 22),
      ),
    ],
  );
}
