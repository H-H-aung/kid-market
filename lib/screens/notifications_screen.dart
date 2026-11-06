import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _unreadOnly = false;
  bool _saving = false;

  Future<void> _open(AppNotification item) async {
    if (_saving) return;
    final store = AppScope.of(context);
    setState(() => _saving = true);
    final ok =
        store.isNotificationRead(item.id) ||
        await saveAction(context, () => store.markNotificationRead(item.id));
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OrdersScreen(orderId: item.orderId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final unread = store.unreadNotificationCount;
    final items = store.notifications
        .where((item) => !_unreadOnly || !store.isNotificationRead(item.id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            onPressed: _saving || unread == 0
                ? null
                : () async {
                    setState(() => _saving = true);
                    await saveAction(context, store.markAllNotificationsRead);
                    if (mounted) setState(() => _saving = false);
                  },
            icon: const Icon(Icons.done_all_rounded),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unread == 0
                        ? "You're all caught up"
                        : '$unread unread ${unread == 1 ? 'notification' : 'notifications'}',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your latest activity, all in one place.',
                    style: TextStyle(color: muted, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: !_unreadOnly,
                        onSelected: (_) => setState(() => _unreadOnly = false),
                      ),
                      ChoiceChip(
                        label: Text('Unread ($unread)'),
                        selected: _unreadOnly,
                        onSelected: (_) => setState(() => _unreadOnly = true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyState(
                  Icons.notifications_none_rounded,
                  _unreadOnly
                      ? 'No unread notifications'
                      : 'No notifications yet',
                  _unreadOnly
                      ? 'You have read all your updates.'
                      : 'Updates appear here when you save an order.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                24 + MediaQuery.paddingOf(context).bottom,
              ),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final item = items[i];
                  final isRead = store.isNotificationRead(item.id);
                  final date = MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(item.createdAt.toLocal());
                  final time = MaterialLocalizations.of(context)
                      .formatTimeOfDay(
                        TimeOfDay.fromDateTime(item.createdAt.toLocal()),
                        alwaysUse24HourFormat:
                            MediaQuery.alwaysUse24HourFormatOf(context),
                      );
                  return Semantics(
                    label: isRead ? 'Read notification' : 'Unread notification',
                    child: Material(
                      color: isRead ? Colors.white : const Color(0xFFEFF6FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: BorderSide(
                          color: isRead
                              ? const Color(0xFFE8EEF5)
                              : const Color(0xFFCEE3FF),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: _saving ? null : () => _open(item),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isRead
                                      ? const Color(0xFFF0F4F9)
                                      : const Color(0xFFDCEBFF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_outlined,
                                  color: blue,
                                  size: 23,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: ink,
                                            ),
                                          ),
                                        ),
                                        if (!isRead)
                                          const Padding(
                                            padding: EdgeInsets.only(left: 6),
                                            child: Icon(
                                              Icons.circle,
                                              color: blue,
                                              size: 8,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.message,
                                      style: const TextStyle(
                                        color: muted,
                                        height: 1.5,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$date · $time',
                                      style: const TextStyle(
                                        color: muted,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'View order',
                                      style: TextStyle(
                                        color: blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
