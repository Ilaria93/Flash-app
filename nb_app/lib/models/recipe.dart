class Recipe {
  final String id;
  final String title;
  final int time;
  final int servings;
  final String imageUrl;
  final List<String> ingredients;
  final String difficulty;

  Recipe({
    required this.id,
    required this.title,
    required this.time,
    required this.servings,
    required this.imageUrl,
    required this.ingredients,
    required this.difficulty,
  });

  static List<Recipe> mockRecipes = [
    Recipe(
      id: '1',
      title: 'Spaghetti Carbonara',
      time: 25,
      servings: 4,
      imageUrl: 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=600',
      ingredients: ['Pasta', 'Eggs', 'Bacon', 'Parmesan'],
      difficulty: 'Easy',
    ),
    Recipe(
      id: '2',
      title: 'Chicken Tikka Masala',
      time: 45,
      servings: 4,
      imageUrl: 'https://images.pexels.com/photos/2474661/pexels-photo-2474661.jpeg?auto=compress&cs=tinysrgb&w=600',
      ingredients: ['Chicken', 'Tomato', 'Onion', 'Spices'],
      difficulty: 'Medium',
    ),
    // Add more mock recipes as needed
  ];
}