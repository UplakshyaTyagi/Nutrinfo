import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/scan_history_model.dart';
import '../models/review_model.dart';

/// Centralized HTTP client for all Nutrinfo API calls.
///
/// Base URL is resolved per-platform:
///  - Android emulator → 10.0.2.2 (host machine proxy)
///  - Web / Desktop    → localhost
///  - Physical device  → set via [baseUrl] constructor param
///
/// All authenticated endpoints attach `Authorization: Bearer <token>`.
class ApiClient {
  /// Your PC's local-network IP for physical-device testing.
  /// Find via `ipconfig` (Windows) or `ifconfig` (macOS/Linux).
  static const String _physicalDeviceIp = '10.159.62.227';

  static String get _defaultBaseUrl {
    if (kIsWeb) return 'http://localhost:8000/api/v1';
    if (Platform.isAndroid) {
      // 10.0.2.2 is the emulator proxy; for physical devices use LAN IP.
      // Set to false when using emulator, true when using a real device.
      const usePhysicalDevice = true;
      return usePhysicalDevice
          ? 'http://$_physicalDeviceIp:8000/api/v1'
          : 'http://10.0.2.2:8000/api/v1';
    }
    return 'http://localhost:8000/api/v1';
  }

  final String baseUrl;
  final http.Client _client;

  ApiClient({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? _defaultBaseUrl,
        _client = client ?? http.Client();

  Map<String, String> _authHeaders(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  // ─── Auth ───────────────────────────────────────────────

  /// Sync Auth0 user with backend DB. Called after login/signup.
  Future<UserModel> syncUser({
    required String token,
    String? displayName,
    String? email,
    String dietaryFocus = 'None',
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/sync'),
      headers: _authHeaders(token),
      body: jsonEncode({
        'display_name': displayName,
        'email': email,
        'dietary_focus': dietaryFocus,
      }),
    );
    _throwOnError(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return UserModel.fromJson(json['user'] as Map<String, dynamic>);
  }

  // ─── Scan ───────────────────────────────────────────────

  /// Upload a product image for ML analysis. Returns the full product data.
  Future<ProductModel> scanProduct({
    required String token,
    required Uint8List imageBytes,
    String filename = 'scan.jpg',
  }) async {
    final uri = Uri.parse('$baseUrl/scan');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: filename,
      ));

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    _throwOnError(response);

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    return ProductModel.fromJson(data);
  }

  // ─── Products ───────────────────────────────────────────

  /// Fetch a single cached product by ID.
  Future<ProductModel> getProduct({
    required String token,
    required String productId,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/products/$productId'),
      headers: _authHeaders(token),
    );
    _throwOnError(response);
    return ProductModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ─── History ────────────────────────────────────────────

  /// Get the authenticated user's scan history (joined with product).
  Future<List<ScanHistoryModel>> getHistory({
    required String token,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/history?limit=$limit&offset=$offset'),
      headers: _authHeaders(token),
    );
    _throwOnError(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => ScanHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ─── Reviews ────────────────────────────────────────────

  /// Get all reviews for a product (public, no auth required).
  Future<List<ReviewModel>> getReviews({required String productId}) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/reviews/$productId'),
    );
    _throwOnError(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Create a new review on a product.
  Future<ReviewModel> createReview({
    required String token,
    required String productId,
    required int rating,
    required String body,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/reviews'),
      headers: _authHeaders(token),
      body: jsonEncode({
        'product_id': productId,
        'rating': rating,
        'body': body,
      }),
    );
    _throwOnError(response);
    return ReviewModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ─── Helpers ────────────────────────────────────────────

  void _throwOnError(http.Response response) {
    if (response.statusCode >= 400) {
      String detail = 'Request failed with status ${response.statusCode}';
      try {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        detail = json['detail'] as String? ?? detail;
      } catch (_) {}
      throw ApiException(response.statusCode, detail);
    }
  }

  void dispose() => _client.close();
}

/// Custom exception for API errors with status code and message.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
