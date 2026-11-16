import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_mart/screens/orders_screen.dart';
import 'package:kids_mart/screens/profile_screen.dart';
import 'package:kids_mart/screens/wishlist_screen.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> openProfile(WidgetTester tester, {double scale = 1}) async {
  await tester.pumpWidget(
    AppScope(
      store: AppStore(preferences: await SharedPreferences.getInstance()),
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: const Scaffold(body: ProfileScreen()),
      ),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  for (final width in [320.0, 390.0]) {
    testWidgets('Profile scrolls without overflow at $width with larger text', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await openProfile(tester, scale: 1.5);
      expect(find.text('Guest shopping'), findsOneWidget);
      expect(
        find.text('No sign-in needed. Your details are requested at checkout.'),
        findsOneWidget,
      );
      expect(find.byType(Image), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(find.text('About Kids Mart'), 200);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final title in ['Order tracking', 'My Wishlist']) {
    testWidgets('$title shortcut opens its destination', (tester) async {
      await openProfile(tester);
      await tester.scrollUntilVisible(find.text(title), 150);
      await tester.pumpAndSettle();
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
      expect(
        find.byType(title == 'Order tracking' ? OrdersScreen : WishlistScreen),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Guest profile has no auth or personal-detail form', (
    tester,
  ) async {
    await openProfile(tester);
    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('Edit profile'), findsNothing);
    expect(
      find.text('Your order number appears after checkout'),
      findsOneWidget,
    );
    expect(find.text('Add them now or during checkout'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Help and about actions open useful content', (tester) async {
    await openProfile(tester);
    await tester.scrollUntilVisible(find.text('How it works'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('How it works'));
    await tester.pumpAndSettle();
    expect(find.text('Add details at checkout'), findsOneWidget);
    Navigator.of(tester.element(find.text('Add details at checkout'))).pop();
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
