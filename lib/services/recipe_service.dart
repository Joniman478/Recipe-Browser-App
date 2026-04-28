import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_category.dart';
import '../models/meal.dart';

/// Service that wraps the MealDB API (free, no key required).
/// Base URL: https://www.themealdb.com/api/json/v1/1
///
/// Endpoints used:
///   GET /categories.php          — all categories
///   GET /filter.php?c={category} — meals in a category
///   GET /lookup.php?i={mealId}   — full meal details
class RecipeService {
  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  /// GET /categories.php — returns all meal categories.
  Future<List<MealCategory>> getCategories() async {
    final response =
        await http.get(Uri.parse('$_base/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List raw = data['categories'] ?? [];
      return raw.map((c) => MealCategory.fromJson(c)).toList();
    }
    throw Exception('Failed to load categories');
  }

  /// GET /filter.php?c={category} — returns all meals in a category.
  /// Note: this endpoint returns lightweight meal data (id, name, thumb only).
  /// Full details are fetched separately via [getMealById].
  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http
        .get(Uri.parse('$_base/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List raw = data['meals'] ?? [];
      return raw.map((m) => Meal.fromFilterJson(m)).toList();
    }
    throw Exception('Failed to load meals for category: $category');
  }

  /// GET /lookup.php?i={mealId} — returns full meal details including
  /// ingredients with measures, instructions, and YouTube link.
  Future<Meal?> getMealById(String id) async {
    final response =
        await http.get(Uri.parse('$_base/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List raw = data['meals'] ?? [];
      if (raw.isNotEmpty) return Meal.fromJson(raw.first);
    }
    return null;
  }
}
