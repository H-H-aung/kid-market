import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/notifications_screen.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/widgets/home_header.dart';

Future<SavedOrder> placeOrder(AppStore store, {int productIndex = 0}) async {
  await store.saveAddress(
    const SavedAddress(
      id: 'home',
      recipient: 'Parent',
      phone: '09123456789',
      address: '12 Learning Road',
    ),
  );
  await store.addToCart(products[productIndex]);
  return store.checkout();
}

Future<void> mount(
  WidgetTester tester,
  AppStore store,
  Widget screen, {
  double scale = 1,
}) async {
  await tester.pumpWidget(
    AppScope(
      store: store,
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'Notifications derive from saved orders and read state persists with older saved data',
    () async {
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      await store.saveProfile('Parent', 'parent@example.com');
      final order = await placeOrder(store);
      final oldData =
          jsonDecode(preferences.getString(AppStore.storageKey)!)
              as Map<String, dynamic>;
      oldData.remove('readNotificationIds');
      await preferences.setString(AppStore.storageKey, jsonEncode(oldData));
      final restored = AppStore(preferences: preferences);
      expect(restored.name, 'Parent');
      expect(restored.notifications.single.orderId, order.id);
      expect(restored.unreadNotificationCount, 1);
      await restored.markNotificationRead(restored.notifications.single.id);
      final reopened = AppStore(preferences: preferences);
      expect(reopened.unreadNotificationCount, 0);
      expect(reopened.orders.single.id, order.id);
    },
  );

  test(
    'Failed checkout creates no notification and failed read save keeps unread state',
    () async {
      var fail = false;
      final store = AppStore(persist: (_) async => !fail);
      await store.saveAddress(
        const SavedAddress(
          id: 'home',
          recipient: 'Parent',
          phone: '09123456789',
          address: 'Learning Road',
        ),
      );
      await store.addToCart(products.first);
      fail = true;
      await expectLater(store.checkout(), throwsStateError);
      expect(store.notifications, isEmpty);
      fail = false;
      await store.checkout();
      fail = true;
      await expectLater(store.markAllNotificationsRead(), throwsStateError);
      expect(store.unreadNotificationCount, 1);
      fail = false;
      await store.markAllNotificationsRead();
      expect(store.unreadNotificationCount, 0);
    },
  );

  testWidgets(
    'Header opens notifications, mark all persists and unread filter empties',
    (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      await placeOrder(store);
      await placeOrder(store, productIndex: 1);
      await mount(tester, store, const Scaffold(body: HomeHeader()));
      await tester.tap(find.byTooltip('Notifications, 2 unread'));
      await tester.pumpAndSettle();
      expect(find.byType(NotificationsScreen), findsOneWidget);
      expect(find.text('Order saved'), findsNWidgets(2));
      await tester.tap(find.byTooltip('Mark all as read'));
      await tester.pumpAndSettle();
      expect(AppStore(preferences: preferences).unreadNotificationCount, 0);
      await tester.tap(find.text('Unread (0)'));
      await tester.pumpAndSettle();
      expect(find.text('No unread notifications'), findsOneWidget);
      Navigator.of(tester.element(find.byType(NotificationsScreen))).pop();
      await tester.pumpAndSettle();
      expect(find.byTooltip('Notifications'), findsOneWidget);
      expect(find.byTooltip('Notifications, 2 unread'), findsNothing);
    },
  );

  testWidgets(
    'Tapping an unread notification opens the matching expanded order and updates badge',
    (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      final older = await placeOrder(store);
      final latest = await placeOrder(store, productIndex: 1);
      await mount(tester, store, const Scaffold(body: HomeHeader()));
      await tester.tap(find.byTooltip('Notifications, 2 unread'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('View order').first);
      await tester.pumpAndSettle();
      expect(find.byType(OrdersScreen), findsOneWidget);
      expect(find.text('Order details'), findsOneWidget);
      expect(find.text(latest.id), findsOneWidget);
      expect(find.text(older.id), findsNothing);
      expect(find.text('${products[1].title} × 1'), findsOneWidget);
      expect(AppStore(preferences: preferences).unreadNotificationCount, 1);
      Navigator.of(tester.element(find.byType(OrdersScreen))).pop();
      await tester.pumpAndSettle();
      Navigator.of(tester.element(find.byType(NotificationsScreen))).pop();
      await tester.pumpAndSettle();
      expect(find.byTooltip('Notifications, 1 unread'), findsOneWidget);
    },
  );

  for (final width in [320.0, 390.0]) {
    testWidgets(
      'Empty and populated notifications fit $width with larger text',
      (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final store = AppStore();
        await mount(tester, store, const NotificationsScreen(), scale: 1.5);
        expect(find.text('No notifications yet'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await placeOrder(store);
        await tester.pumpAndSettle();
        expect(find.text('1 unread notification'), findsOneWidget);
        expect(find.text('Order saved'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Read save failure leaves the notification unread and permits retry',
    (tester) async {
      var fail = false;
      final store = AppStore(persist: (_) async => !fail);
      await placeOrder(store);
      await mount(tester, store, const NotificationsScreen());
      fail = true;
      await tester.tap(find.text('View order'));
      await tester.pumpAndSettle();
      expect(store.unreadNotificationCount, 1);
      expect(find.byType(OrdersScreen), findsNothing);
      expect(
        find.text('Could not save changes. Please try again.'),
        findsOneWidget,
      );
      fail = false;
      await tester.tap(find.text('View order'));
      await tester.pumpAndSettle();
      expect(find.byType(OrdersScreen), findsOneWidget);
      expect(store.unreadNotificationCount, 0);
    },
  );
}
