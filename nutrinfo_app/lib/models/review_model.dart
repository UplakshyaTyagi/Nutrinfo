class ReviewModel {
  final String id;
  final String userId;
  final String productId;
  final int rating;
  final String body;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.body,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 3,
      body: json['body'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
