import 'package:flutter_test/flutter_test.dart';
import 'package:kids_mart/data/app_data.dart';

void main() {
  test('Demo catalog has balanced categories and stable unique IDs', () {
    expect(categories, hasLength(4));
    expect(products, hasLength(20));
    expect(products.map((product) => product.id).toSet(), hasLength(20));

    for (final category in categories) {
      expect(
        products.where((product) => product.categoryId == category.id),
        hasLength(5),
        reason: '${category.title} should have five demo products',
      );
    }
  });
}
