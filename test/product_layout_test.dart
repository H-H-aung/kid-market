import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jojo/data/app_data.dart';
import 'package:jojo/screens/product_list_screen.dart';
import 'package:jojo/widgets/glass_nav.dart';

void main() {
  for (final width in [320.0, 390.0, 800.0]) {
    testWidgets('Product grid fits $width and adds the selected product', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final added = [];
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: ProductListScreen(title: 'Products', onAdd: added.add),
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Add ${products.first.title} to cart'));
      expect(added, [products.first]);
      await tester.tap(find.text(products.first.title));
      await tester.pumpAndSettle();
      expect(find.text('Add to Cart'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Glass navigation retains labels, cart badge and tab callbacks', (
    tester,
  ) async {
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: GlassNav(
            index: 0,
            cartCount: 2,
            onTap: (value) => selected = value,
          ),
        ),
      ),
    );
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.text('Cart'));
    expect(selected, 2);
    expect(tester.takeException(), isNull);
  });
}
