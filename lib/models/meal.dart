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

  /// Builds a [Meal] from a full /lookup.php response object,
  /// combining the 20 strIngredientX / strMeasureX pairs.
  factory Meal.fromJson(Map<String, dynamic> json) {
    final List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i']?.toString().trim() ?? '';
      final measure = json['strMeasure$i']?.toString().trim() ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(measure.isNotEmpty ? '$measure $ingredient' : ingredient);
      }
    }

    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strCategory: json['strCategory'],
      strArea: json['strArea'],
      strInstructions: json['strInstructions'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
    );
  }

  /// Lightweight constructor used when only thumbnail data is
  /// available (e.g. from /filter.php) — full details loaded later.
  factory Meal.fromFilterJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      ingredients: [],
    );
  }
}
