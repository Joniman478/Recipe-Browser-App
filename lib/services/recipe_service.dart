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
        instructions:
            '1. Peel and finely chop 4 large onions. Dry-cook them in a heavy pot over medium heat, stirring constantly, for 15–20 minutes until very soft and lightly golden — no oil yet.\n\n'
            '2. Add 3 tbsp niter kibbeh (Ethiopian spiced clarified butter) and stir to coat the onions.\n\n'
            '3. Add 3–4 tbsp berbere spice blend. Stir and cook for 5 minutes until the spices are fragrant and the mixture is deep red.\n\n'
            '4. Pour in 1 cup of water or chicken broth to deglaze. Season with salt to taste.\n\n'
            '5. Add the chicken pieces (skin removed, scored to absorb flavor). Stir well, cover, and simmer on low heat for 35–45 minutes, stirring occasionally, until the chicken is fully cooked and tender.\n\n'
            '6. Gently add 4 hard-boiled eggs (pierced a few times with a fork) into the stew. Simmer for a further 10 minutes so the eggs absorb the sauce.\n\n'
            '7. Adjust seasoning and serve hot on a large piece of injera, with extra injera on the side for scooping.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Ethiopian_wat.jpg/960px-Ethiopian_wat.jpg',
        youtubeUrl: 'https://youtu.be/zi4AT6uYKUs?si=x32Qxq6hLFRadrAD',
        ingredients: [
          '1 Whole Chicken (cut into pieces)',
          '4 large Onions',
          '3–4 tbsp Berbere spice',
          '3 tbsp Niter Kibbeh',
          '4 Eggs (hard-boiled)',
          '1 cup Chicken Broth',
          'Salt to taste',
          'Injera for serving',
        ],
      ),
      Recipe(
        id: 'eth_2',
        title: 'Kitfo',
        category: 'Beef',
        area: 'Ethiopian',
        instructions:
            '1. Choose a very lean cut of beef (such as eye of round or sirloin). Trim all fat and sinew. Freeze for 20 minutes to make slicing easier.\n\n'
            '2. Using a very sharp knife, mince the beef as finely as possible — almost like a paste. Do not use a food processor as it changes the texture.\n\n'
            '3. Gently warm 3 tbsp niter kibbeh in a small pan over the lowest possible heat — it should be just melted and fragrant, not sizzling.\n\n'
            '4. Mix 1–2 tsp mitmita (or to taste) into the warm niter kibbeh.\n\n'
            '5. Combine the spiced butter with the minced beef and mix gently but thoroughly. Season with salt.\n\n'
            '6. Kitfo is traditionally served leb leb (slightly warmed) — if preferred, warm gently in the pan for 1–2 minutes, stirring constantly; do not fully cook it.\n\n'
            '7. Serve immediately on injera alongside a generous portion of ayibe (fresh Ethiopian cheese) and gomen (sautéed collard greens) if available.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/85/Kitfo_with_Ayibe..JPG',
        youtubeUrl: 'https://youtu.be/ugkktxv00_Q?si=LVN4ZSNersvqVM4i',
        ingredients: [
          '1 lb (450g) very lean Beef',
          '3 tbsp Niter Kibbeh',
          '1–2 tsp Mitmita spice',
          'Salt to taste',
          'Ayibe (fresh Ethiopian cheese)',
          'Injera for serving',
        ],
      ),
      Recipe(
        id: 'eth_3',
        title: 'Injera (Flatbread)',
        category: 'Side',
        area: 'Ethiopian',
        instructions:
            '1. Combine 2 cups of teff flour with 2½ cups of lukewarm water in a large bowl. Stir until smooth, then loosely cover with a clean cloth.\n\n'
            '2. Leave at room temperature to ferment for 2–3 days, stirring once a day. The batter is ready when it smells pleasantly sour and small bubbles appear on the surface.\n\n'
            '3. On cooking day, add a pinch of salt. Thin the batter with up to ½ cup of room-temperature water — it should be pourable, like thin pancake batter.\n\n'
            '4. Heat a non-stick skillet or mitad (traditional clay griddle) over medium-high heat until very hot. Lightly grease if needed.\n\n'
            '5. Pour enough batter to cover the entire surface in a thin, even layer, starting from the outside and spiraling inward. Reduce heat to medium.\n\n'
            '6. Cover with a lid immediately and cook for 2–3 minutes. Injera is ready when the surface is fully set, bubbly, and the edges begin to lift — do not flip.\n\n'
            '7. Slide onto a clean surface and allow to cool. Stack on a plate lined with a cloth. Serve as the base and utensil for Ethiopian stews.',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtlcbBBF_qcDt8x_4Gs6mUM9kfW4jnRQMnVw&s',
        youtubeUrl: 'https://youtu.be/HacFKtsVihA?si=81vI9g7DX7tAfS-z',
        ingredients: [
          '2 cups Teff Flour',
          '2½ cups Lukewarm Water (+ up to ½ cup more)',
          'Pinch of Salt',
        ],
      ),
      Recipe(
        id: 'eth_4',
        title: 'Misir Wat (Red Lentil Stew)',
        category: 'Vegetarian',
        area: 'Ethiopian',
        instructions:
            '1. Rinse 1 cup of red lentils thoroughly under cold water until the water runs clear. Set aside.\n\n'
            '2. Finely dice 2 medium onions. Dry-cook them in a heavy pot over medium heat for 10–15 minutes, stirring often, until very soft and golden.\n\n'
            '3. Add 2 tbsp niter kibbeh (or regular butter/oil for vegan). Stir in 3 minced garlic cloves and 1 tsp freshly grated ginger. Cook for 2 minutes.\n\n'
            '4. Add 2–3 tbsp berbere spice. Stir and cook for 3–4 minutes, letting the spices bloom and the mixture darken to a deep red.\n\n'
            '5. Add the rinsed lentils and 2½ cups of water or vegetable broth. Stir to combine. Bring to a boil.\n\n'
            '6. Reduce heat to low, partially cover, and simmer for 25–30 minutes, stirring every 5–10 minutes, until the lentils have fully broken down and the stew is thick and creamy. Add water as needed.\n\n'
            '7. Season with salt. Serve hot on injera with other wats (stews) or vegetable sides.',
        imageUrl: 'https://i0.wp.com/mealsbymavis.com/wp-content/uploads/2019/09/misirwat_2.png?fit=1200%2C800&ssl=1',
        ingredients: [
          '1 cup Red Lentils',
          '2 medium Onions',
          '3 cloves Garlic',
          '1 tsp fresh Ginger',
          '2–3 tbsp Berbere spice',
          '2 tbsp Niter Kibbeh',
          '2½ cups Vegetable Broth or Water',
          'Salt to taste',
          'Injera for serving',
        ],
      ),
    ];
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    if (query.isEmpty || query.toLowerCase().contains('ethiopian')) {
      return _getEthiopianRecipes();
    }

    // Check if the query matches any Ethiopian recipe by name
    final lowerQuery = query.toLowerCase();
    final ethiopianMatches = _getEthiopianRecipes()
        .where((r) => r.title.toLowerCase().contains(lowerQuery))
        .toList();
    if (ethiopianMatches.isNotEmpty) {
      return ethiopianMatches;
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
