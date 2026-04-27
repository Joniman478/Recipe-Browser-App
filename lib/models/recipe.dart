class Recipe {
  final String id;
  final String title;
  final String category;
  final String area;
  final String instructions;
  final String imageUrl;
  final String? youtubeUrl;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.area,
    required this.instructions,
    required this.imageUrl,
    this.youtubeUrl,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final measureString = measure != null ? measure.toString().trim() : '';
        final ingredientString = measureString.isNotEmpty 
            ? "$measureString $ingredient".trim()
            : ingredient.toString().trim();
        ingredients.add(ingredientString);
      }
    }

    return Recipe(
      id: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}
