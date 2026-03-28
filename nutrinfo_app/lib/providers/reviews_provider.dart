import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review_model.dart';
import '../services/api_client.dart';
import 'auth_provider.dart';

/// Fetches reviews for a specific product.
///
/// Usage: `ref.watch(reviewsProvider(productId))`
final reviewsProvider =
    FutureProvider.family<List<ReviewModel>, String>((ref, productId) async {
  final api = ref.read(apiClientProvider);
  return api.getReviews(productId: productId);
});

/// Helper to submit a new review. Call this then invalidate reviewsProvider.
Future<ReviewModel> submitReview({
  required ApiClient api,
  required String token,
  required String productId,
  required int rating,
  required String body,
}) async {
  return api.createReview(
    token: token,
    productId: productId,
    rating: rating,
    body: body,
  );
}
