import 'package:flutter/material.dart';
import 'package:nonbuttarlo_app/widgets/ingredient_chip.dart';
import 'package:nonbuttarlo_app/widgets/recipe_card.dart';
import 'package:nonbuttarlo_app/models/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _suggestedIngredients = [
    'Pomodoro',
    'Uovo',
    'Formaggio',
    'Riso',
    'Tonno',
    'Cipolla',
    'Zucchine',
    'Aglio',
  ];

  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty && !_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
        _ingredientController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.eco, color: Color(0xFF4CAF50), size: 32),
                  const SizedBox(width: 8),
                  Text(
                    'Non Buttarlo!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Scopri cosa puoi cucinare con ciò che hai!',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Ingredient input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientController,
                      decoration: InputDecoration(
                        hintText: 'Aggiungi un ingrediente',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSubmitted: _addIngredient,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _addIngredient(_ingredientController.text),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Suggested
              const Text(
                'Suggerimenti rapidi:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _suggestedIngredients.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ActionChip(
                      label: Text(_suggestedIngredients[index]),
                      onPressed: () =>
                          _addIngredient(_suggestedIngredients[index]),
                      backgroundColor: const Color(0xFFFFE0B2),
                    );
                  },
                ),
              ),

              // Ingredient list
              if (_ingredients.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'I miei ingredienti:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _ingredients
                      .map((ing) => IngredientChip(
                            ingredient: ing,
                            onRemove: () => _removeIngredient(ing),
                          ))
                      .toList(),
                ),
              ],

              // Recipes
              if (_ingredients.isNotEmpty) ...[
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ricette consigliate:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Vedi tutte'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Recipe.mockRecipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: RecipeCard(recipe: Recipe.mockRecipes[index]),
                      );
                    },
                  ),
                ),
              ],

              // Smart suggestion
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Aggiungi '),
                      TextSpan(
                        text: 'formaggio',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5722),
                        ),
                      ),
                      TextSpan(text: ' e potresti preparare '),
                      TextSpan(
                        text: 'una frittata gustosa!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
