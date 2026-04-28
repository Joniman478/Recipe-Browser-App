import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  List<Recipe> _getEthiopianRecipes() {
    return [
      Recipe(
        id: 'eth_1',
        title: 'Doro Wat (Spicy Chicken Stew)',
        category: 'Chicken',
        area: 'Ethiopian',
        instructions: '1. Sauté onions until caramelized.\n2. Add berbere spice and niter kibbeh.\n3. Add chicken pieces and simmer.\n4. Serve with hard-boiled eggs and injera.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Ethiopian_wat.jpg/960px-Ethiopian_wat.jpg',
        ingredients: ['3 Onions', '2 tbsp Berbere', '1 Whole Chicken', '4 Eggs', 'Injera'],
      ),
      Recipe(
        id: 'eth_2',
        title: 'Kitfo',
        category: 'Beef',
        area: 'Ethiopian',
        instructions: '1. Finely mince lean beef.\n2. Warm niter kibbeh (spiced butter) and mix with mitmita (spice blend).\n3. Combine beef with spiced butter mixture.\n4. Serve slightly warm or raw with ayibe (cheese) and injera.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/85/Kitfo_with_Ayibe..JPG',
        ingredients: ['1 lb Lean Beef', '2 tbsp Mitmita', '3 tbsp Niter Kibbeh', 'Ayibe (Cottage Cheese)', 'Injera'],
      ),
      Recipe(
        id: 'eth_3',
        title: 'Injera (Flatbread)',
        category: 'Side',
        area: 'Ethiopian',
        instructions: '1. Mix teff flour with water and let it ferment for 2-3 days.\n2. Thin the batter with hot water.\n3. Pour batter onto a hot circular griddle (mitad).\n4. Cover and cook until bubbles form and the top is spongy.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Injera_with_eight_kinds_of_stew.jpg/960px-Injera_with_eight_kinds_of_stew.jpg',
        ingredients: ['2 cups Teff Flour', '3 cups Water', 'Pinch of salt'],
      ),
      Recipe(
        id: 'eth_4',
        title: 'Misir Wat (Red Lentil Stew)',
        category: 'Vegetarian',
        area: 'Ethiopian',
        instructions: '1. Sauté onions, garlic, and ginger.\n2. Add berbere spice.\n3. Stir in red lentils and water or vegetable broth.\n4. Simmer until lentils are soft and the sauce thickens.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Ethiopian_wat.jpg/960px-Ethiopian_wat.jpg',
        ingredients: ['1 cup Red Lentils', '1 Onion', '2 tbsp Berbere', '3 cloves Garlic', '1 tbsp Niter Kibbeh'],
      ),
    ];
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    if (query.isEmpty || query.toLowerCase() == 'ethiopian') {
      return _getEthiopianRecipes();
    }

    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];
      return meals.map((meal) => Recipe.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Recipe?> getRecipeById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List meals = data['meals'] ?? [];
      if (meals.isNotEmpty) {
        return Recipe.fromJson(meals.first);
      }
    }
    return null;
  }
}
