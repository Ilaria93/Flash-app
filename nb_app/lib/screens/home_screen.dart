import 'package:flutter/material.dart';
import 'package:nonbuttarlo_app/widgets/ingredient_chip.dart';
import 'package:nonbuttarlo_app/services/ai_food_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  List<Map<String, dynamic>> _recipes = [];
  Map<String, dynamic>? _currentTips;
  Map<String, dynamic>? _smartSuggestions;
  bool _isLoading = false;

  final List<String> _suggestedIngredients = [
    'Carote',
    'Pomodoro',
    'Uovo',
    'Formaggio',
    'Riso',
    'Cipolla',
    'Zucchine',
    'Aglio',
  ];

  void _addIngredient(String ingredient) async {
    if (ingredient.isNotEmpty && !_ingredients.contains(ingredient)) {
      setState(() {
        _ingredients.add(ingredient);
        _ingredientController.clear();
      });

      // Cerca ricette con tutti gli ingredienti
      await _searchRecipesForAllIngredients();

      // Ottieni consigli specifici per l'ultimo ingrediente aggiunto
      await _getIngredientTips(ingredient);
    }
  }

  // Metodo per cercare ricette con tutti gli ingredienti selezionati
  Future<void> _searchRecipesForAllIngredients() async {
    if (_ingredients.isEmpty) {
      setState(() {
        _recipes = [];
        _smartSuggestions = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔍 Cercando ricette con ingredienti: ${_ingredients.join(", ")}');

      // Cerca ricette E suggerimenti intelligenti in parallelo
      final futures = await Future.wait([
        AIFoodService.getRecipesByIngredients(_ingredients),
        AIFoodService.getSmartCombinationSuggestions(_ingredients),
      ]);

      final recipes = futures[0] as List<Map<String, dynamic>>;
      final suggestions = futures[1] as Map<String, dynamic>;

      setState(() {
        _recipes = recipes;
        _smartSuggestions = suggestions;
        _isLoading = false;
      });

      // Messaggio personalizzato basato sul numero di ingredienti
      String message = '';
      if (_ingredients.length == 1) {
        message =
            'Trovate ${recipes.length} ricette per ${_ingredients.first}! Aggiungi altri ingredienti per combinazioni più specifiche 🎯';
      } else if (_ingredients.length == 2) {
        message =
            'Perfetto! ${recipes.length} ricette per la combinazione ${_ingredients.join(" + ")} 🤝';
      } else {
        message =
            'Fantastico! ${recipes.length} ricette complete con tutti i tuoi ${_ingredients.length} ingredienti! 🎉';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF4CAF50),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore nella ricerca ricette: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Metodo per ottenere consigli su un ingrediente specifico
  Future<void> _getIngredientTips(String ingredient) async {
    try {
      final tips = await AIFoodService.getIngredientTips(ingredient);
      setState(() {
        _currentTips = tips;
      });
    } catch (e) {
      print('Errore nel caricamento dei consigli per $ingredient: $e');
    }
  }

  void _removeIngredient(String ingredient) async {
    setState(() {
      _ingredients.remove(ingredient);
    });

    // Ricerca ricette con i nuovi ingredienti (dopo la rimozione)
    await _searchRecipesForAllIngredients();
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
              // Header con logo e saluto
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/cute_vegetables_hero.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Logo
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Emoji verdure kawaii
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('🥕', style: TextStyle(fontSize: 28)),
                              Text('🍅', style: TextStyle(fontSize: 28)),
                              Text('🥬', style: TextStyle(fontSize: 28)),
                              Text('🧅', style: TextStyle(fontSize: 28)),
                              Text('🥒', style: TextStyle(fontSize: 28)),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Titolo principale con sfondo semi-trasparente
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Ciao,',
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    color: const Color(0xFF4CAF50),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'cosa cuciniamo oggi?',
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    color: const Color(0xFF4CAF50),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Sottotitolo
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Dimmi l\'ingrediente e io ti dirò come sfruttarlo al meglio',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.black87,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sezione ingredienti
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seleziona i tuoi ingredienti',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ingredientController,
                            decoration: InputDecoration(
                              hintText: 'Aggiungi un ingrediente...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            onSubmitted: _addIngredient,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () =>
                                _addIngredient(_ingredientController.text),
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'I miei ingredienti:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton.icon(
                        onPressed: _searchRecipesForAllIngredients,
                        icon: const Icon(Icons.search,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Cerca ricette',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: const Size(0, 0),
                        ),
                      ),
                    ),
                  ],
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
                const SizedBox(height: 12),
                Text(
                  'Ingredienti selezionati: ${_ingredients.length} • Tocca "Cerca ricette" per trovare nuove idee!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              // Suggerimenti intelligenti per combinazioni
              if (_smartSuggestions != null &&
                  (_smartSuggestions!['suggestions'] as List).isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Suggerimenti AI intelligenti',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Livello ${_smartSuggestions!['combination_level']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _smartSuggestions!['message'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_smartSuggestions!['suggestions'] as List)
                            .map((suggestion) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.blue.withOpacity(0.5)),
                                  ),
                                  child: InkWell(
                                    onTap: () =>
                                        _addIngredient(suggestion.toString()),
                                    borderRadius: BorderRadius.circular(20),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            suggestion.toString(),
                                            style: TextStyle(
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.add_circle_outline,
                                            size: 14,
                                            color: Colors.blue[600],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],

              // Ricette consigliate
              if (_recipes.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.restaurant,
                              color: Color(0xFF4CAF50)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ricette trovate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Con ingredienti: ${_ingredients.join(", ")}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_recipes.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ...(_recipes
                            .map((recipe) => Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(recipe['time']),
                                          const SizedBox(width: 16),
                                          Text(recipe['difficulty']),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        recipe['description'],
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      if (recipe['ai_note'] != null) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Colors.blue
                                                    .withOpacity(0.3)),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(Icons.smart_toy,
                                                  size: 16,
                                                  color: Colors.blue[600]),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  recipe['ai_note'],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blue[700],
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // TODO: Naviga alla pagina della ricetta
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF4CAF50),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('Vedi ricetta'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList()),
                    ],
                  ),
                ),
              ],

              // Consigli dello chef
              if (_currentTips != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.lightbulb, color: Color(0xFF4CAF50)),
                          SizedBox(width: 8),
                          Text(
                            'Consigli dello chef',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...(_currentTips!['tips'] as List<dynamic>)
                          .map((tip) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Color(0xFF4CAF50), size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        tip.toString(),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
