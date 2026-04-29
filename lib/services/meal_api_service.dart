import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal_category.dart';
import '../models/meal.dart';
import 'api_exception.dart';

/// Service class responsible for all network communication with TheMealDB API.
class MealApiService {
  static const String _host = 'www.themealdb.com';
  static const String _pathPrefix = '/api/json/v1/1';
  
  /// 10-second timeout for all network requests.
  final Duration _timeout = const Duration(seconds: 10);
  
  /// Standard headers for JSON communication.
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Validates the HTTP response and throws a custom [ApiException] if not successful.
  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(
        response.statusCode,
        'Server returned a non-200 status',
      );
    }
  }

  /// Fetches the list of all meal categories.
  Future<List<MealCategory>> getCategories() async {
    final uri = Uri.https(_host, '$_pathPrefix/categories.php');
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List raw = data['categories'] as List? ?? [];
    return raw.map((c) => MealCategory.fromJson(c as Map<String, dynamic>)).toList();
  }

  /// Fetches meals filtered by a specific category name.
  Future<List<Meal>> getMealsByCategory(String category) async {
    final uri = Uri.https(_host, '$_pathPrefix/filter.php', {'c': category});
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List raw = data['meals'] as List? ?? [];
    return raw.map((m) => Meal.fromFilterJson(m as Map<String, dynamic>)).toList();
  }

  /// Fetches full meal details for a specific meal ID.
  Future<Meal?> getMealById(String id) async {
    final uri = Uri.https(_host, '$_pathPrefix/lookup.php', {'i': id});
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List raw = data['meals'] as List? ?? [];
    if (raw.isNotEmpty) {
      return Meal.fromJson(raw.first as Map<String, dynamic>);
    }
    return null;
  }

  /// Searches for meals by name using the search query string.
  Future<List<Meal>> searchMeals(String query) async {
    if (query.trim().isEmpty) return [];
    
    final uri = Uri.https(_host, '$_pathPrefix/search.php', {'s': query});
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final data = json.decode(response.body) as Map<String, dynamic>;
    final List raw = data['meals'] as List? ?? [];
    return raw.map((m) => Meal.fromJson(m as Map<String, dynamic>)).toList();
  }
}
