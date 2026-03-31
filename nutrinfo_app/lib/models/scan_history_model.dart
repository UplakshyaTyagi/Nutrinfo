import 'product_model.dart';

class ScanHistoryModel {
  final String id;
  final String userId;
  final String productId;
  final bool dietaryConflict;
  final DateTime scannedAt;
  final ProductModel? product;

  ScanHistoryModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.dietaryConflict,
    required this.scannedAt,
    this.product,
  });

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      dietaryConflict: json['dietary_conflict'] as bool? ?? false,
      scannedAt:
          DateTime.tryParse(json['scanned_at'] as String? ?? '') ??
          DateTime.now(),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }
}
