import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/screens/profile_screen.dart';
import 'package:kids_mart/screens/wishlist_screen.dart';

Future<void> openProfile(WidgetTester tester, {double scale = 1}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: child!,
      ),
      home: const Scaffold(body: ProfileScreen()),
    ),
  );
}

void main() {
  for (final width in [320.0, 390.0]) {
    testWidgets('Profile scrolls without overflow at $width with larger text', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await openProfile(tester, scale: 1.5);
      expect(find.text('Little Explorer'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('About Kids Mart'), 200);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final title in ['My Orders', 'My Wishlist']) {
    testWidgets('$title shortcut opens its destination', (tester) async {
      await openProfile(tester);
      await tester.scrollUntilVisible(find.text(title), 150);
      await tester.pumpAndSettle();
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      expect(
        find.byType(title == 'My Orders' ? OrdersScreen : WishlistScreen),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Demo edit validates fields and updates the profile', (
    tester,
  ) async {
    await openProfile(tester);
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '');
    await tester.enterText(fields.last, 'invalid-email');
    await tester.ensureVisible(find.text('Save changes'));
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name'), findsOneWidget);
    expect(find.text('Enter a valid email'), findsOneWidget);
    await tester.enterText(fields.first, 'Happy Explorer');
    await tester.enterText(fields.last, 'explorer@example.com');
    await tester.ensureVisible(find.text('Save changes'));
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Happy Explorer'), findsOneWidget);
    expect(find.text('explorer@example.com'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Help and about actions open useful content', (tester) async {
    await openProfile(tester);
    await tester.scrollUntilVisible(find.text('Help & Support'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Help & Support'));
    await tester.pumpAndSettle();
    expect(find.text('A little help'), findsOneWidget);
    Navigator.of(tester.element(find.text('A little help'))).pop();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('About Kids Mart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About Kids Mart'));
    await tester.pumpAndSettle();
    expect(find.byType(AboutDialog), findsOneWidget);
    expect(find.text('1.0.0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
