import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

/// Fetches a single product by ID from the cache.
///
/// Usage: `ref.watch(productProvider(productId))`
final productProvider =
    FutureProvider.family<ProductModel, String>((ref, productId) async {
  final token = ref.read(authTokenProvider);
  if (token == null) throw Exception('Not authenticated');

  final api = ref.read(apiClientProvider);
  return api.getProduct(token: token, productId: productId);
});
