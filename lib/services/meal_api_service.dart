import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/meal_category.dart';
import '../models/meal.dart';
import 'api_exception.dart';

class MealApiService {
  final String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  final Duration _timeout = const Duration(seconds: 10);
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(
        response.statusCode,
        'Server returned a non-200 status',
      );
    }
  }

  Future<List<MealCategory>> getCategories() async {
    final uri = Uri.parse('$_baseUrl/categories.php');
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final data = json.decode(response.body);
    final List raw = data['categories'] as List? ?? [];
    return raw.map((c) => MealCategory.fromJson(c as Map<String, dynamic>)).toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final uri = Uri.parse('$_baseUrl/filter.php?c=$category');
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final data = json.decode(response.body);
    final List raw = data['meals'] as List? ?? [];
    return raw.map((m) => Meal.fromFilterJson(m as Map<String, dynamic>)).toList();
  }

  Future<Meal?> getMealById(String id) async {
    final uri = Uri.parse('$_baseUrl/lookup.php?i=$id');
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _checkResponse(response);

    final data = json.decode(response.body);
    final List raw = data['meals'] as List? ?? [];
    if (raw.isNotEmpty) {
      return Meal.fromJson(raw.first as Map<String, dynamic>);
    }
    return null;
  }
}
