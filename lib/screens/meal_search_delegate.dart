import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../services/api_exception.dart';
import 'meal_detail_screen.dart';

class MealSearchDelegate extends SearchDelegate<String?> {
  final MealApiService _service = MealApiService();
  Timer? _debounceTimer;

  @override
  String get searchFieldLabel => 'Search recipes...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return Center(
        child: Text(
          'Type to search for recipes...',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return FutureBuilder<List<Meal>>(
      future: _service.searchMeals(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          final error = snapshot.error!;
          String errorMsg = 'An unexpected error occurred';
          if (error.toString().contains('SocketException') ||
              error.toString().contains('Failed to fetch') ||
              error.toString().contains('ClientException')) {
            errorMsg = 'Network error or no internet connection';
          } else if (error is TimeoutException) {
            errorMsg = 'Request timed out';
          } else if (error is ApiException) {
            errorMsg = 'Server error: ${error.message}';
          }
          
          return Center(
            child: Text(
              errorMsg,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        final meals = snapshot.data;
        if (meals == null || meals.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }

        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: meal.strMealThumb,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.restaurant, size: 24),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 60,
                    height: 60,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              title: Text(
                meal.strMeal,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                [meal.strCategory, meal.strArea]
                    .where((s) => s != null && s.isNotEmpty)
                    .join(' • '),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MealDetailScreen(mealId: meal.idMeal),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
