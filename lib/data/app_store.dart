import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kids_mart/data/app_data.dart' as demo;
import 'package:kids_mart/models/product.dart';

class SavedAddress {
  final String id, recipient, phone, address;
  const SavedAddress({
    required this.id,
    required this.recipient,
    required this.phone,
    required this.address,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'recipient': recipient,
    'phone': phone,
    'address': address,
  };
  factory SavedAddress.fromJson(Map<String, dynamic> j) => SavedAddress(
    id: j['id'] as String,
    recipient: j['recipient'] as String,
    phone: j['phone'] as String,
    address: j['address'] as String,
  );
  String get summary => '$recipient\n$phone\n$address';
}

class OrderLine {
  final String productId, title;
  final int quantity, unitCents;
  const OrderLine({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.unitCents,
  });
  int get totalCents => quantity * unitCents;
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'title': title,
    'quantity': quantity,
    'unitCents': unitCents,
  };
  factory OrderLine.fromJson(Map<String, dynamic> j) => OrderLine(
    productId: j['productId'] as String,
    title: j['title'] as String,
    quantity: j['quantity'] as int,
    unitCents: j['unitCents'] as int,
  );
}

class SavedOrder {
  final String id;
  final DateTime createdAt;
  final List<OrderLine> lines;
  final SavedAddress address;
  SavedOrder({
    required this.id,
    required this.createdAt,
    required List<OrderLine> lines,
    required this.address,
  }) : lines = List.unmodifiable(lines);
  int get totalCents => lines.fold(0, (sum, line) => sum + line.totalCents);
  Map<String, dynamic> toJson() => {
    'id': id,
    'createdAt': createdAt.toIso8601String(),
    'lines': lines.map((e) => e.toJson()).toList(),
    'address': address.toJson(),
  };
  factory SavedOrder.fromJson(Map<String, dynamic> j) => SavedOrder(
    id: j['id'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    lines: (j['lines'] as List)
        .map((e) => OrderLine.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    address: SavedAddress.fromJson(
      Map<String, dynamic>.from(j['address'] as Map),
    ),
  );
}

class AppNotification {
  final String id, orderId;
  final DateTime createdAt;
  const AppNotification({
    required this.id,
    required this.orderId,
    required this.createdAt,
  });
  String get title => 'Order saved';
  String get message =>
      'Your order $orderId was saved on this device. No payment was collected.';
}

class AppStore extends ChangeNotifier {
  static const storageKey = 'kids_mart.account.v1';
  final Future<bool> Function(String)? _persist;
  final List<Product> catalog;
  String _name = '', _email = '';
  final Map<String, int> _cart = {};
  final Set<String> _wishlist = {};
  final List<SavedAddress> _addresses = [];
  final List<SavedOrder> _orders = [];
  final Set<String> _readNotificationIds = {};
  String? _defaultAddressId;
  Future<void> _pending = Future<void>.value();

  AppStore({
    SharedPreferences? preferences,
    Future<bool> Function(String)? persist,
    this.catalog = demo.products,
  }) : _persist =
           persist ??
           (preferences == null
               ? null
               : (value) => preferences.setString(storageKey, value)) {
    final raw = preferences?.getString(storageKey);
    if (raw != null) _restore(jsonDecode(raw) as Map<String, dynamic>);
  }
  static Future<AppStore> open() async =>
      AppStore(preferences: await SharedPreferences.getInstance());
  String get name => _name;
  String get email => _email;
  Map<String, int> get cart => Map.unmodifiable(_cart);
  List<Product> get cartProducts =>
      catalog.where((p) => _cart.containsKey(p.id)).toList();
  List<Product> get wishlistProducts =>
      catalog.where((p) => _wishlist.contains(p.id)).toList();
  List<SavedAddress> get addresses => List.unmodifiable(_addresses);
  List<SavedOrder> get orders => List.unmodifiable(_orders);
  List<AppNotification> get notifications => _orders
      .map(
        (order) => AppNotification(
          id: 'order:${order.id}',
          orderId: order.id,
          createdAt: order.createdAt,
        ),
      )
      .toList(growable: false);
  bool isNotificationRead(String id) => _readNotificationIds.contains(id);
  int get unreadNotificationCount =>
      notifications.where((item) => !isNotificationRead(item.id)).length;
  SavedAddress? get defaultAddress =>
      _addresses.where((a) => a.id == _defaultAddressId).firstOrNull;
  int get cartCount => _cart.values.fold(0, (sum, count) => sum + count);
  int get totalCents => cartProducts.fold(
    0,
    (sum, p) => sum + (p.price * 100).round() * _cart[p.id]!,
  );
  bool isFavourite(Product product) => _wishlist.contains(product.id);

  Map<String, dynamic> _snapshot() => {
    'name': _name,
    'email': _email,
    'cart': Map<String, int>.from(_cart),
    'wishlist': _wishlist.toList(),
    'addresses': _addresses.map((a) => a.toJson()).toList(),
    'defaultAddressId': _defaultAddressId,
    'orders': _orders.map((o) => o.toJson()).toList(),
    'readNotificationIds': _readNotificationIds.toList(),
  };
  void _restore(Map<String, dynamic> j) {
    _readNotificationIds
      ..clear()
      ..addAll((j['readNotificationIds'] as List? ?? []).cast<String>());
    _name = j['name'] as String? ?? '';
    _email = j['email'] as String? ?? '';
    _cart.clear();
    for (final entry in Map<String, dynamic>.from(
      j['cart'] as Map? ?? {},
    ).entries) {
      final count = entry.value as int;
      if (count > 0 && catalog.any((p) => p.id == entry.key)) {
        _cart[entry.key] = count.clamp(1, 99);
      }
    }
    _wishlist
      ..clear()
      ..addAll((j['wishlist'] as List? ?? []).cast<String>());
    _addresses
      ..clear()
      ..addAll(
        (j['addresses'] as List? ?? []).map(
          (a) => SavedAddress.fromJson(Map<String, dynamic>.from(a as Map)),
        ),
      );
    _defaultAddressId = j['defaultAddressId'] as String?;
    _orders
      ..clear()
      ..addAll(
        (j['orders'] as List? ?? []).map(
          (o) => SavedOrder.fromJson(Map<String, dynamic>.from(o as Map)),
        ),
      );
  }

  Future<void> _change(VoidCallback update) {
    final operation = _pending.then((_) async {
      final before = _snapshot();
      try {
        update();
        if (_persist != null && !await _persist(jsonEncode(_snapshot()))) {
          throw StateError('Could not save changes');
        }
      } catch (_) {
        _restore(before);
        notifyListeners();
        rethrow;
      }
      notifyListeners();
    });
    _pending = operation.catchError((Object _) {});
    return operation;
  }

  Future<void> saveProfile(String name, String email) => _change(() {
    if (name.trim().isEmpty ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.trim())) {
      throw ArgumentError('Enter your name and a valid email');
    }
    _name = name.trim();
    _email = email.trim();
  });
  Future<void> markNotificationRead(String id) => _change(() {
    if (!notifications.any((item) => item.id == id)) {
      throw ArgumentError('Notification not found');
    }
    _readNotificationIds.add(id);
  });
  Future<void> markAllNotificationsRead() => _change(() {
    _readNotificationIds.addAll(notifications.map((item) => item.id));
  });
  Future<void> addToCart(Product product, {int quantity = 1}) => _change(() {
    if (!catalog.any((p) => p.id == product.id) || quantity < 1) {
      throw ArgumentError('Invalid product or quantity');
    }
    final next = (_cart[product.id] ?? 0) + quantity;
    if (next > 99) throw StateError('Maximum quantity is 99');
    _cart[product.id] = next;
  });
  Future<void> setQuantity(Product product, int quantity) => _change(() {
    if (quantity < 0 || quantity > 99) {
      throw ArgumentError('Quantity must be between 0 and 99');
    }
    if (quantity == 0) {
      _cart.remove(product.id);
    } else if (catalog.any((p) => p.id == product.id)) {
      _cart[product.id] = quantity;
    }
  });
  Future<void> toggleFavourite(Product product) => _change(() {
    if (!catalog.any((p) => p.id == product.id)) {
      throw ArgumentError('Unknown product');
    }
    if (!_wishlist.remove(product.id)) _wishlist.add(product.id);
  });
  Future<void> saveAddress(SavedAddress address) => _change(() {
    if (address.recipient.trim().isEmpty ||
        address.address.trim().isEmpty ||
        !RegExp(r'^\+?[\d\s()-]{7,20}$').hasMatch(address.phone.trim())) {
      throw ArgumentError('Enter a name, phone number and address');
    }
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index < 0) {
      _addresses.add(address);
    } else {
      _addresses[index] = address;
    }
    _defaultAddressId ??= address.id;
  });
  Future<void> removeAddress(String id) => _change(() {
    _addresses.removeWhere((a) => a.id == id);
    if (_defaultAddressId == id) _defaultAddressId = _addresses.firstOrNull?.id;
  });
  Future<void> setDefaultAddress(String id) => _change(() {
    if (!_addresses.any((a) => a.id == id)) {
      throw ArgumentError('Address not found');
    }
    _defaultAddressId = id;
  });
  Future<SavedOrder> checkout() async {
    SavedOrder? order;
    await _change(() {
      if (_cart.isEmpty) throw StateError('Your cart is empty');
      final address = defaultAddress;
      if (address == null) throw StateError('Add a delivery address first');
      final now = DateTime.now();
      order = SavedOrder(
        id: 'KM-${now.microsecondsSinceEpoch}',
        createdAt: now,
        address: address,
        lines: cartProducts
            .map(
              (p) => OrderLine(
                productId: p.id,
                title: p.title,
                quantity: _cart[p.id]!,
                unitCents: (p.price * 100).round(),
              ),
            )
            .toList(),
      );
      _orders.insert(0, order!);
      _cart.clear();
    });
    return order!;
  }
}

class AppScope extends InheritedNotifier<AppStore> {
  const AppScope({super.key, required AppStore store, required super.child})
    : super(notifier: store);
  static AppStore? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()?.notifier;
  static AppStore of(BuildContext context) {
    final store = maybeOf(context);
    assert(store != null, 'AppScope is required');
    return store!;
  }
}

Future<bool> saveAction(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (context.mounted && success != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    }
    return true;
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save changes. Please try again.'),
        ),
      );
    }
    return false;
  }
}
