import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/notifications_screen.dart';
import 'package:kids_mart/widgets/brand_logo.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppScope.maybeOf(context);
    final count = store?.unreadNotificationCount ?? 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          const Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: BrandLogo(),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            tooltip: count == 0
                ? 'Notifications'
                : 'Notifications, $count unread',
            onPressed: store == null
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(48, 48),
            ),
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text(count > 99 ? '99+' : '$count'),
              child: const Icon(Icons.notifications_none_rounded, color: ink),
            ),
          ),
        ],
      ),
    );
  }
}
