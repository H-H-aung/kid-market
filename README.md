# Kids Mart

A Flutter learning-products app with four categories, search, favourites, a quantity-aware cart, saved addresses, profile editing, order history and a notification inbox.

## Run

```powershell
flutter pub get
flutter run
```

## Working shopping flow

1. Browse or search Home and Explore.
2. Tap a product's heart to add it to My Wishlist.
3. Select a quantity on the product detail page and add it to the cart.
4. Add, edit or choose a delivery address in Profile > Saved addresses or in the cart.
5. Review the cart and confirm Save order.
6. The order appears in My Orders, including its saved quantities, prices and delivery address. The cart clears only after the save succeeds.

Profile, addresses, cart, favourites and orders persist on the current device using shared preferences. Changes are serialized; failed saves restore the previous state. Removing an address later does not change addresses on existing orders.

The header bell opens Notifications. Saved orders appear there automatically; tapping one opens that order's details. Unread badges, All/Unread filters and Mark all as read reflect saved read status, including after restarting the app. These are in-app updates, not background push notifications.

## Current scope

The catalog is still demo data in `lib/data/app_data.dart`. Checkout records an order **on this device only**. It does not send an order to a merchant, collect payment or sync between devices. Authentication, a product/order backend and a payment service still need integration before a live shop launch.

Clearing app data or uninstalling the app removes these local records.

## Verification

```powershell
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug --no-pub
```

Tests cover persistence, failed-save rollback, duplicate checkout prevention, address editing, wishlist/cart interactions, search, profile validation and responsive layouts.
