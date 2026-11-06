import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/screens/addresses_screen.dart';
import 'package:kids_mart/screens/cart_screen.dart';
import 'package:kids_mart/screens/home_screen.dart';
import 'package:kids_mart/screens/product_details_screen.dart';
import 'package:kids_mart/screens/wishlist_screen.dart';
import 'package:kids_mart/widgets/product_card.dart';

Future<void> mount(WidgetTester tester, AppStore store, Widget screen) async {
  await tester.pumpWidget(
    AppScope(
      store: store,
      child: MaterialApp(theme: ThemeData(useMaterial3: true), home: screen),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets(
    'Address can be added, edited, made default and deleted through UI',
    (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      await mount(tester, store, const AddressesScreen());
      await tester.tap(find.text('Add address'));
      await tester.pumpAndSettle();
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Parent');
      await tester.enterText(fields.at(1), '09123456789');
      await tester.enterText(fields.at(2), '12 Learning Road');
      await tester.ensureVisible(find.text('Save address'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save address'));
      await tester.pumpAndSettle();
      expect(store.addresses, hasLength(1));
      expect(find.text('Default address'), findsOneWidget);
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.enterText(fields.at(2), '24 Learning Road');
      await tester.ensureVisible(find.text('Save address'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save address'));
      await tester.pumpAndSettle();
      expect(
        AppStore(preferences: preferences).defaultAddress?.address,
        '24 Learning Road',
      );
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(TextButton, 'Delete'),
        ),
      );
      await tester.pumpAndSettle();
      expect(store.addresses, isEmpty);
      expect(AppStore(preferences: preferences).addresses, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Favourite and selected quantity persist and wishlist can add to cart',
    (tester) async {
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      await mount(
        tester,
        store,
        ProductDetailsScreen(product: products.first, onAdd: (_) {}),
      );
      await tester.tap(find.byTooltip('Save favourite'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Increase quantity'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      expect(store.cartCount, 2);
      expect(
        AppStore(preferences: preferences).isFavourite(products.first),
        isTrue,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await mount(tester, store, const WishlistScreen());
      await tester.tap(find.byTooltip('Add to cart'));
      await tester.pumpAndSettle();
      expect(store.cartCount, 3);
      await tester.tap(find.byTooltip('Remove favourite'));
      await tester.pumpAndSettle();
      expect(find.text('No favourites yet'), findsOneWidget);
      expect(AppStore(preferences: preferences).wishlistProducts, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Cart quantity updates, checkout records order, clears cart and opens history',
    (tester) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      await store.addToCart(products.first);
      await store.saveAddress(
        const SavedAddress(
          id: 'home',
          recipient: 'Parent',
          phone: '09123456789',
          address: '12 Learning Road',
        ),
      );
      await mount(tester, store, CartScreen(onContinueShopping: () {}));
      await tester.tap(find.byTooltip('Increase ${products.first.title}'));
      await tester.pumpAndSettle();
      expect(store.cartCount, 2);
      await tester.scrollUntilVisible(find.text('Review order'), 150);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Review order'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save order'));
      await tester.pumpAndSettle();
      expect(find.text('Your order has been saved'), findsOneWidget);
      expect(store.cartCount, 0);
      expect(store.orders.single.totalCents, 1700);
      expect(AppStore(preferences: preferences).orders, hasLength(1));
      await tester.tap(find.text('View orders'));
      await tester.pumpAndSettle();
      expect(find.text(store.orders.single.id), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Home search filters, displays no results and clears correctly', (
    tester,
  ) async {
    final store = AppStore();
    await mount(tester, store, Scaffold(body: HomeScreen(onAdd: (_) {})));
    await tester.enterText(find.byType(TextField), 'blocks');
    await tester.pumpAndSettle();
    expect(find.text('Building Blocks Set'), findsOneWidget);
    expect(find.text('Good Night Stories'), findsNothing);
    expect(find.byType(ProductCard), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'missing item');
    await tester.pumpAndSettle();
    expect(find.text('No products found'), findsOneWidget);
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('No products found'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
