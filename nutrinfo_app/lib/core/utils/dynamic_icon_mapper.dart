import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DynamicIconMapper {
  /// Returns a PhosphorIcon based on keyword matching in the product name.
  static IconData getIconForProduct(String productName) {
    final lowerName = productName.toLowerCase();

    if (lowerName.contains('milk') ||
        lowerName.contains('cheese') ||
        lowerName.contains('yogurt') ||
        lowerName.contains('dairy')) {
      return PhosphorIconsRegular.drop; // Dairy
    }
    if (lowerName.contains('coffee') ||
        lowerName.contains('tea') ||
        lowerName.contains('espresso')) {
      return PhosphorIconsRegular.coffee;
    }
    if (lowerName.contains('water') || lowerName.contains('hydration')) {
      return PhosphorIconsRegular.dropHalf; // Better for water
    }
    if (lowerName.contains('bread') ||
        lowerName.contains('toast') ||
        lowerName.contains('bagel') ||
        lowerName.contains('bun')) {
      return PhosphorIconsRegular.cookie; // Closest to bread/bakery
    }
    if (lowerName.contains('chocolate') ||
        lowerName.contains('candy') ||
        lowerName.contains('sweet')) {
      return PhosphorIconsRegular.cookie;
    }
    if (lowerName.contains('fruit') ||
        lowerName.contains('apple') ||
        lowerName.contains('berry') ||
        lowerName.contains('banana') ||
        lowerName.contains('jam')) {
      return PhosphorIconsRegular.plant; // Fruit/Veggies
    }
    if (lowerName.contains('meat') ||
        lowerName.contains('beef') ||
        lowerName.contains('chicken') ||
        lowerName.contains('pork') ||
        lowerName.contains('fish')) {
      return PhosphorIconsRegular.fish; // Meats
    }
    if (lowerName.contains('protein') ||
        lowerName.contains('whey') ||
        lowerName.contains('shake') ||
        lowerName.contains('bar')) {
      return PhosphorIconsRegular.lightning; // Energy / Supplement
    }
    if (lowerName.contains('snack') || lowerName.contains('chip')) {
      return PhosphorIconsRegular.popcorn;
    }
    if (lowerName.contains('egg')) {
      return PhosphorIconsRegular.egg;
    }
    if (lowerName.contains('pizza')) {
      return PhosphorIconsRegular.pizza;
    }

    // Default premium fallback icon for general boxed/packaged goods
    return PhosphorIconsRegular.package;
  }
}
