import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

/// Scans a product image via the backend ML pipeline.
///
/// Usage: `ref.read(scanProductProvider(imageBytes).future)`
/// Returns the full ProductModel from the /scan endpoint.
final scanProductProvider =
    FutureProvider.family<ProductModel, Uint8List>((ref, imageBytes) async {
  final token = ref.read(authTokenProvider);
  if (token == null) throw Exception('Not authenticated');

  final api = ref.read(apiClientProvider);
  return api.scanProduct(token: token, imageBytes: imageBytes);
});
