import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kids_mart/api/api_config.dart';

/// Shared HTTP client for the Shop API.
class ApiClient {
  final http.Client? _client;
  const ApiClient({http.Client? client}) : _client = client;

  Future<Object?> get(
    String path, {
    Map<String, Object?> queryParameters = const {},
    String? accessToken,
  }) => request(
    'GET',
    path,
    queryParameters: queryParameters,
    accessToken: accessToken,
  );

  Future<Object?> post(String path, {Object? body, String? accessToken}) =>
      request('POST', path, body: body, accessToken: accessToken);
  Future<Object?> patch(String path, {Object? body, String? accessToken}) =>
      request('PATCH', path, body: body, accessToken: accessToken);
  Future<Object?> delete(String path, {String? accessToken}) =>
      request('DELETE', path, accessToken: accessToken);

  Future<Object?> request(
    String method,
    String path, {
    Object? body,
    Map<String, Object?> queryParameters = const {},
    String? accessToken,
  }) async {
    final client = _client ?? http.Client();
    try {
      final uri = Uri.parse(ApiConfig.shopBaseUrl)
          .resolve(path)
          .replace(
            queryParameters: queryParameters.map(
              (key, value) => MapEntry(key, value?.toString() ?? ''),
            ),
          );
      final request = http.Request(method, uri)
        ..headers.addAll({
          'Accept': 'application/json',
          if (body != null) 'Content-Type': 'application/json',
          if (accessToken != null && accessToken.isNotEmpty)
            'Authorization': 'Bearer $accessToken',
        });
      if (body != null) request.body = jsonEncode(body);
      final response = await http.Response.fromStream(
        await client.send(request).timeout(const Duration(seconds: 15)),
      );
      final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(
          'Request failed (${response.statusCode})',
          statusCode: response.statusCode,
          response: decoded,
        );
      }
      return decoded;
    } on FormatException {
      throw const ApiException('The API returned invalid JSON.');
    } finally {
      if (_client == null) client.close();
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? response;
  const ApiException(this.message, {this.statusCode, this.response});
  @override
  String toString() => message;
}
