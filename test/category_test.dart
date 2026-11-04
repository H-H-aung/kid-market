import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/screens/explore_screen.dart';
import 'package:kids_mart/screens/product_list_screen.dart';
import 'package:kids_mart/widgets/category_widgets.dart';

void main() {
  testWidgets(
    'Compact category row scrolls on a small screen and filters products',
    (tester) async {
      tester.view.physicalSize = const Size(320, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: Scaffold(body: ExploreScreen(onAdd: (_) {})),
        ),
      );
      expect(find.byType(CategoryTile), findsNWidgets(4));
      expect(
        tester.getSize(find.byType(CategoryTile).first).height,
        lessThan(160),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getTopLeft(find.byType(CategoryTile).first).dy,
        tester.getTopLeft(find.byType(CategoryTile).last).dy,
      );
      await tester.ensureVisible(find.text('Toys'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Toys'));
      await tester.pumpAndSettle();
      expect(find.text('Building Blocks Set'), findsOneWidget);
      expect(find.text('Good Night Stories'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Empty category offers a useful empty state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProductListScreen(
          title: 'Books',
          categoryId: 'books',
          items: const [],
          onAdd: (_) {},
        ),
      ),
    );
    expect(find.text('More discoveries soon'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Category view accepts fewer items without indexing errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryRow(
            items: [categories.first],
            productItems: const [],
            onSelected: (_) {},
          ),
        ),
      ),
    );
    expect(find.byType(CategoryTile), findsOneWidget);
    expect(find.text('0 items'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
