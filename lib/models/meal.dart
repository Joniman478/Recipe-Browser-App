/// Model representing a single meal from the MealDB API.
/// Fields match the API response: idMeal, strMeal, strMealThumb,
/// strCategory, strArea, strInstructions, strYoutube, and
/// a combined ingredients list (ingredient + measure).
class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strYoutube;
  final List<String> ingredients; // each entry: "measure ingredient"

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strYoutube,
    required this.ingredients,
  });

  /// Builds a [Meal] from a full /lookup.php response object.
  /// Iterates through up to 20 strIngredient and strMeasure fields to combine them.
  factory Meal.fromJson(Map<String, dynamic> json) {
    final List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (json['strMeasure$i'] as String?)?.trim() ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(measure.isNotEmpty ? '$measure $ingredient' : ingredient);
      }
    }

    return Meal(
      idMeal: json['idMeal'] as String? ?? '',
      strMeal: json['strMeal'] as String? ?? '',
      strMealThumb: json['strMealThumb'] as String? ?? '',
      strCategory: json['strCategory'] as String?,
      strArea: json['strArea'] as String?,
      strInstructions: json['strInstructions'] as String?,
      strYoutube: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }

  /// Factory constructor for parsing results from the filter endpoint.
  /// Note: This response contains fewer fields than the full lookup.
  factory Meal.fromFilterJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'] as String? ?? '',
      strMeal: json['strMeal'] as String? ?? '',
      strMealThumb: json['strMealThumb'] as String? ?? '',
      ingredients: const [],
    );
  }

  /// Converts the [Meal] instance back into a JSON-compatible Map.
  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strMealThumb': strMealThumb,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strYoutube': strYoutube,
      'ingredients': ingredients,
    };
  }

  /// Creates a copy of this [Meal] with selected fields replaced by new values.
  Meal copyWith({
    String? idMeal,
    String? strMeal,
    String? strMealThumb,
    String? strCategory,
    String? strArea,
    String? strInstructions,
    String? strYoutube,
    List<String>? ingredients,
  }) {
    return Meal(
      idMeal: idMeal ?? this.idMeal,
      strMeal: strMeal ?? this.strMeal,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      strCategory: strCategory ?? this.strCategory,
      strArea: strArea ?? this.strArea,
      strInstructions: strInstructions ?? this.strInstructions,
      strYoutube: strYoutube ?? this.strYoutube,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
