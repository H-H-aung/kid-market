import 'package:kids_mart/api/api_client.dart';

/// Routes for Kids World Education Shop API v1.
class ShopApi {
  final ApiClient _client;
  String? accessToken;
  ShopApi({ApiClient client = const ApiClient(), this.accessToken})
    : _client = client;

  Future<bool> healthCheck() async {
    try {
      final response = await _client.get('');
      return response is Map && response['success'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<Object?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) => _client.post(
    'auth/register',
    body: {'name': name, 'email': email, 'password': password, 'phone': phone},
  );
  Future<Object?> login({required String email, required String password}) =>
      _client.post('auth/login', body: {'email': email, 'password': password});
  Future<Object?> categories() => _client.get('categories');
  Future<Object?> products({
    int page = 1,
    int limit = 20,
    int? categoryId,
    String? search,
    ProductSort? sort,
  }) {
    final query = <String, Object?>{'page': page, 'limit': limit};
    if (categoryId != null) {
      query['category_id'] = categoryId;
    }
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    if (sort != null) {
      query['sort'] = sort.apiValue;
    }
    return _client.get('products', queryParameters: query);
  }

  Future<Object?> product(int id) => _client.get('products/$id');

  Future<Object?> me() => _get('auth/me');
  Future<Object?> wishlist() => _get('wishlist');
  Future<Object?> addWishlist(int productId) => _post('wishlist/$productId');
  Future<Object?> removeWishlist(int productId) =>
      _delete('wishlist/$productId');
  Future<Object?> cart() => _get('cart');
  Future<Object?> addToCart({required int productId, required int quantity}) =>
      _post('cart', body: {'product_id': productId, 'quantity': quantity});
  Future<Object?> updateCartItem({
    required int productId,
    required int quantity,
  }) => _patch('cart/$productId', body: {'quantity': quantity});
  Future<Object?> removeCartItem(int productId) => _delete('cart/$productId');
  Future<Object?> addresses() => _get('addresses');
  Future<Object?> addAddress({
    required String label,
    required String recipientName,
    required String phone,
    required String addressLine1,
    required String city,
    required bool isDefault,
  }) => _post(
    'addresses',
    body: {
      'label': label,
      'recipient_name': recipientName,
      'phone': phone,
      'address_line1': addressLine1,
      'city': city,
      'is_default': isDefault,
    },
  );
  Future<Object?> updateAddress(int id, Map<String, Object?> changes) =>
      _patch('addresses/$id', body: changes);
  Future<Object?> removeAddress(int id) => _delete('addresses/$id');
  Future<Object?> orders({int page = 1, int limit = 20}) =>
      _get('orders', queryParameters: {'page': page, 'limit': limit});
  Future<Object?> order(int id) => _get('orders/$id');
  Future<Object?> createOrder({
    required int addressId,
    required String paymentMethod,
    String? note,
  }) => _post(
    'orders',
    body: {
      'address_id': addressId,
      'payment_method': paymentMethod,
      if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
    },
  );
  Future<Object?> notifications({int page = 1, int limit = 20}) =>
      _get('notifications', queryParameters: {'page': page, 'limit': limit});
  Future<Object?> markNotificationRead(int id) =>
      _patch('notifications/$id/read');
  Future<Object?> updateProfile({String? name, String? phone}) => _patch(
    'profile',
    body: {
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
    },
  );

  Future<Object?> _get(
    String path, {
    Map<String, Object?> queryParameters = const {},
  }) =>
      _client.get(path, queryParameters: queryParameters, accessToken: _token);
  Future<Object?> _post(String path, {Object? body}) =>
      _client.post(path, body: body, accessToken: _token);
  Future<Object?> _patch(String path, {Object? body}) =>
      _client.patch(path, body: body, accessToken: _token);
  Future<Object?> _delete(String path) =>
      _client.delete(path, accessToken: _token);
  String get _token {
    final token = accessToken;
    if (token == null || token.isEmpty) {
      throw const ApiException('Sign in is required for this request.');
    }
    return token;
  }
}

enum ProductSort { priceAsc, priceDesc }

extension on ProductSort {
  String get apiValue => switch (this) {
    ProductSort.priceAsc => 'price_asc',
    ProductSort.priceDesc => 'price_desc',
  };
}
