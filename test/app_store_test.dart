import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kids_mart/data/app_data.dart';
import 'package:kids_mart/data/app_store.dart';

const home = SavedAddress(
  id: 'home',
  recipient: 'Explorer',
  phone: '09123456789',
  address: '12 Learning Road, Yangon',
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'Profile, favourites, cart and addresses survive a new store instance',
    () async {
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      await store.saveProfile('Parent', 'parent@example.com');
      await store.toggleFavourite(products.first);
      await store.addToCart(products.first, quantity: 2);
      await store.saveAddress(home);
      final restored = AppStore(preferences: preferences);
      expect(restored.name, 'Parent');
      expect(restored.email, 'parent@example.com');
      expect(restored.wishlistProducts, [products.first]);
      expect(restored.cart[products.first.id], 2);
      expect(restored.defaultAddress?.summary, home.summary);
      expect(restored.totalCents, 1700);
    },
  );

  test(
    'Checkout persists immutable line and address snapshots and clears cart',
    () async {
      final preferences = await SharedPreferences.getInstance();
      final store = AppStore(preferences: preferences);
      await store.addToCart(products.first, quantity: 2);
      await store.saveAddress(home);
      final order = await store.checkout();
      expect(store.cartCount, 0);
      expect(order.totalCents, 1700);
      await store.removeAddress(home.id);
      final restored = AppStore(preferences: preferences);
      expect(restored.orders.single.id, order.id);
      expect(restored.orders.single.address.summary, home.summary);
      expect(restored.orders.single.lines.single.quantity, 2);
      expect(restored.cartCount, 0);
    },
  );

  test(
    'Checkout requires an address and does not lose the cart on failure',
    () async {
      final store = AppStore();
      await store.addToCart(products.first);
      await expectLater(store.checkout(), throwsStateError);
      expect(store.cartCount, 1);
      expect(store.orders, isEmpty);
    },
  );

  test(
    'Failed disk write rolls back checkout and later retry succeeds',
    () async {
      var failWrites = false;
      final store = AppStore(persist: (_) async => !failWrites);
      await store.addToCart(products.first);
      await store.saveAddress(home);
      failWrites = true;
      await expectLater(store.checkout(), throwsStateError);
      expect(store.cartCount, 1);
      expect(store.orders, isEmpty);
      failWrites = false;
      await store.checkout();
      expect(store.orders, hasLength(1));
      expect(store.cartCount, 0);
    },
  );

  test(
    'Concurrent additions are serialized and duplicate checkout cannot create two orders',
    () async {
      final store = AppStore();
      await Future.wait(
        List.generate(10, (_) => store.addToCart(products.first)),
      );
      expect(store.cartCount, 10);
      await store.saveAddress(home);
      final first = store.checkout();
      final second = expectLater(store.checkout(), throwsStateError);
      await first;
      await second;
      expect(store.orders, hasLength(1));
      expect(store.orders.single.lines.single.quantity, 10);
    },
  );

  test(
    'Removing default address selects another and editing preserves its identity',
    () async {
      final store = AppStore();
      await store.saveAddress(home);
      await store.saveAddress(
        const SavedAddress(
          id: 'work',
          recipient: 'Parent',
          phone: '09987654321',
          address: 'Office Road',
        ),
      );
      await store.setDefaultAddress('work');
      await store.saveAddress(
        const SavedAddress(
          id: 'work',
          recipient: 'Parent',
          phone: '09987654321',
          address: 'New Office Road',
        ),
      );
      expect(store.defaultAddress?.address, 'New Office Road');
      expect(store.addresses, hasLength(2));
      await store.removeAddress('work');
      expect(store.defaultAddress?.id, 'home');
    },
  );

  test(
    'Profile save failure keeps previous values and quantity limit is enforced',
    () async {
      var fail = false;
      final store = AppStore(persist: (_) async => !fail);
      await store.saveProfile('Parent', 'parent@example.com');
      fail = true;
      await expectLater(
        store.saveProfile('Changed', 'new@example.com'),
        throwsStateError,
      );
      expect(store.name, 'Parent');
      fail = false;
      await store.addToCart(products.first, quantity: 99);
      await expectLater(store.addToCart(products.first), throwsStateError);
      expect(store.cartCount, 99);
    },
  );
}
