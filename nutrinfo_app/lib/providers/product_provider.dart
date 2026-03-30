import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

/// Search products by name query — returns list of product maps from backend.
final productSearchProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  final api = ref.read(apiClientProvider);
  return api.searchProducts(query);
});

/// Get a single product by numeric ID.
final productByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, int>((ref, id) async {
  final api = ref.read(apiClientProvider);
  return api.getProduct(id);
});

/// Scan by name — send OCR text to backend for matching.
final scanByNameProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, name) async {
  final api = ref.read(apiClientProvider);
  return api.scanByName(name);
});
