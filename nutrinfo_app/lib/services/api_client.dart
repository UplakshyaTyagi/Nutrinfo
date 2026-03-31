import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;

/// API client for the Nutrinfo backend — no authentication.
class ApiClient {
  // ── Deployment Configuration ────────────────────────────────────────────
  // Set to `true` when building the APK for production (Amazon/GitHub)
  static const bool _isProduction = false;
  // Replace with your actual Render URL later
  static const String _productionUrl = 'https://nutrinfo-api.onrender.com';

  /// Platform-aware base URL.
  /// Physical Android devices use the PC's LAN IP.
  /// Web and desktop use localhost.
  static String get _baseUrl {
    if (_isProduction) return _productionUrl;

    if (kIsWeb) return 'http://localhost:8000';
    if (Platform.isAndroid || Platform.isIOS) {
      // ↓↓↓ PUT YOUR PC's WiFi/LAN IP HERE ↓↓↓
      return 'http://10.254.246.227:8000';
    }
    return 'http://localhost:8000';
  }

  final http.Client _client = http.Client();

  // ── Product Search ──────────────────────────────────────────────────────

  /// Search products by name. Returns list of product maps.
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    if (query.trim().length < 2) return [];

    try {
      final uri = Uri.parse(
        '$_baseUrl/api/v1/products/search',
      ).replace(queryParameters: {'q': query.trim(), 'limit': '20'});
      final response = await _client.get(uri).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('Search error: $e');
    }
    return [];
  }

  // ── Product Detail ──────────────────────────────────────────────────────

  /// Get a single product by numeric ID.
  Future<Map<String, dynamic>?> getProduct(int id) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/v1/products/$id');
      final response = await _client.get(uri).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey('error')) return null;
        return data;
      }
    } catch (e) {
      debugPrint('Get product error: $e');
    }
    return null;
  }

  // ── Trending Swaps ───────────────────────────────────────────────────────

  /// Fetch random top-rated healthy products
  Future<List<Map<String, dynamic>>> getTrendingProducts(int limit) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/v1/products/trending?limit=$limit');
      final response = await _client.get(uri).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('Trending swaps error: $e');
    }
    return [];
  }

  // ── Scan by Name (OCR) ─────────────────────────────────────────────────

  /// Send OCR-extracted text to backend for product matching.
  /// Returns {"found": true, "products": [...]} or {"found": false, "message": "..."}
  Future<Map<String, dynamic>> scanByName(String productName) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/v1/products/scan-by-name');
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'product_name': productName.trim()}),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Scan-by-name error: $e');
    }
    return {'found': false, 'message': 'Could not connect to server.'};
  }
}
