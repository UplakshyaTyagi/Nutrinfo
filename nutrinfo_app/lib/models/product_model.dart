import 'dart:convert';

class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String imageUrl;
  final String ocrIngredientsText;
  final double finalScore;
  final String healthCategory;
  final List<String> insights;
  final double sugarRdaPct;
  final double sodiumRdaPct;
  final int novaGroup;
  final bool isVeg;
  final Map<String, dynamic> offData;
  final List<String> hiddenAdditives;
  final List<String> allergens;
  final DateTime lastFetchedAt;
  final List<ProductModel> healthySwaps;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.imageUrl,
    required this.ocrIngredientsText,
    required this.finalScore,
    required this.healthCategory,
    required this.insights,
    required this.sugarRdaPct,
    required this.sodiumRdaPct,
    required this.novaGroup,
    required this.isVeg,
    required this.offData,
    required this.hiddenAdditives,
    required this.allergens,
    required this.lastFetchedAt,
    this.healthySwaps = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Parse JSON-encoded strings from the backend
    List<String> parseJsonStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) return value.cast<String>();
      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is List) return decoded.cast<String>();
        } catch (_) {}
      }
      return [];
    }

    Map<String, dynamic> parseJsonStringMap(dynamic value) {
      if (value == null) return {};
      if (value is Map) return Map<String, dynamic>.from(value);
      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
        } catch (_) {}
      }
      return {};
    }

    final swapsRaw = json['healthy_swaps'] as List<dynamic>? ?? [];

    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Product',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      ocrIngredientsText: json['ocr_ingredients_text'] as String? ?? '',
      finalScore: (json['final_score'] as num?)?.toDouble() ?? 0.0,
      healthCategory: json['health_category'] as String? ?? 'Eatable',
      insights: parseJsonStringList(json['insights_json']),
      sugarRdaPct: (json['sugar_rda_pct'] as num?)?.toDouble() ?? 0.0,
      sodiumRdaPct: (json['sodium_rda_pct'] as num?)?.toDouble() ?? 0.0,
      novaGroup: (json['nova_group'] as num?)?.toInt() ?? 0,
      isVeg: json['is_veg'] as bool? ?? false,
      offData: parseJsonStringMap(json['off_data_json']),
      hiddenAdditives: parseJsonStringList(json['hidden_additives_json']),
      allergens: parseJsonStringList(json['allergens_json']),
      lastFetchedAt: DateTime.tryParse(json['last_fetched_at'] as String? ?? '') ?? DateTime.now(),
      healthySwaps: swapsRaw.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  /// Nutrient helpers parsed from off_data
  double get protein => (offData['protein'] as num?)?.toDouble() ?? 0.0;
  double get carbs => (offData['carbohydrates'] as num?)?.toDouble() ??
      (offData['energy_kcal'] as num?)?.toDouble() ?? 0.0;
  double get fats => (offData['fat'] as num?)?.toDouble() ??
      (offData['sat_fat'] as num?)?.toDouble() ?? 0.0;
  double get sugars => (offData['sugars'] as num?)?.toDouble() ?? 0.0;
  double get sodium => (offData['sodium'] as num?)?.toDouble() ?? 0.0;
  double get fiber => (offData['fiber'] as num?)?.toDouble() ?? 0.0;
  double get calories => (offData['energy_kcal'] as num?)?.toDouble() ??
      (offData['calories_100g'] as num?)?.toDouble() ?? 0.0;

  /// Map score to display color category
  bool get isHealthy => finalScore >= 6.0;
}
