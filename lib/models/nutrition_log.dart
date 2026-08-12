class FoodItem {
  final String id;
  final String name;
  final String category; // Protein, Carbs, Fats, Fruits, Veggies, Dairy
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final String servingSize;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.servingSize,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'calories': calories,
        'proteinGrams': proteinGrams,
        'carbsGrams': carbsGrams,
        'fatGrams': fatGrams,
        'servingSize': servingSize,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json['id'],
        name: json['name'],
        category: json['category'] ?? 'General',
        calories: json['calories'],
        proteinGrams: (json['proteinGrams'] as num).toDouble(),
        carbsGrams: (json['carbsGrams'] as num).toDouble(),
        fatGrams: (json['fatGrams'] as num).toDouble(),
        servingSize: json['servingSize'],
      );

  static List<FoodItem> get sampleDatabase => [
        FoodItem(id: 'food_1', name: 'Grilled Chicken Breast', category: 'Protein', calories: 165, proteinGrams: 31, carbsGrams: 0, fatGrams: 3.6, servingSize: '100g'),
        FoodItem(id: 'food_2', name: 'White Rice (Cooked)', category: 'Carbs', calories: 130, proteinGrams: 2.7, carbsGrams: 28, fatGrams: 0.3, servingSize: '100g'),
        FoodItem(id: 'food_3', name: 'Whole Eggs (Large)', category: 'Protein', calories: 140, proteinGrams: 12, carbsGrams: 0.8, fatGrams: 9.5, servingSize: '2 eggs'),
        FoodItem(id: 'food_4', name: 'Oatmeal (Rolled Oats)', category: 'Carbs', calories: 150, proteinGrams: 5, carbsGrams: 27, fatGrams: 2.5, servingSize: '40g dry'),
        FoodItem(id: 'food_5', name: 'Atlantic Salmon Fillet', category: 'Protein', calories: 206, proteinGrams: 22, carbsGrams: 0, fatGrams: 12, servingSize: '100g'),
        FoodItem(id: 'food_6', name: 'Greek Yogurt 0%', category: 'Dairy', calories: 90, proteinGrams: 16, carbsGrams: 4, fatGrams: 0, servingSize: '150g'),
        FoodItem(id: 'food_7', name: 'Avocado', category: 'Fats', calories: 160, proteinGrams: 2, carbsGrams: 8.5, fatGrams: 15, servingSize: '100g'),
        FoodItem(id: 'food_8', name: 'Whey Protein Isolate', category: 'Protein', calories: 120, proteinGrams: 25, carbsGrams: 2, fatGrams: 1, servingSize: '1 scoop (30g)'),
        FoodItem(id: 'food_9', name: 'Banana', category: 'Fruits', calories: 105, proteinGrams: 1.3, carbsGrams: 27, fatGrams: 0.3, servingSize: '1 medium'),
        FoodItem(id: 'food_10', name: 'Almonds', category: 'Fats', calories: 164, proteinGrams: 6, carbsGrams: 6, fatGrams: 14, servingSize: '28g'),
      ];
}

class LoggedMealEntry {
  final String id;
  final String mealType; // Breakfast, Lunch, Dinner, Snacks
  final FoodItem food;
  final double quantity; // multiplier of serving size (e.g. 1.5)
  final DateTime loggedAt;

  LoggedMealEntry({
    required this.id,
    required this.mealType,
    required this.food,
    required this.quantity,
    DateTime? loggedAt,
  }) : loggedAt = loggedAt ?? DateTime.now();

  int get totalCalories => (food.calories * quantity).round();
  double get totalProtein => double.parse((food.proteinGrams * quantity).toStringAsFixed(1));
  double get totalCarbs => double.parse((food.carbsGrams * quantity).toStringAsFixed(1));
  double get totalFat => double.parse((food.fatGrams * quantity).toStringAsFixed(1));

  Map<String, dynamic> toJson() => {
        'id': id,
        'mealType': mealType,
        'food': food.toJson(),
        'quantity': quantity,
        'loggedAt': loggedAt.toIso8601String(),
      };

  factory LoggedMealEntry.fromJson(Map<String, dynamic> json) => LoggedMealEntry(
        id: json['id'],
        mealType: json['mealType'],
        food: FoodItem.fromJson(json['food']),
        quantity: (json['quantity'] as num).toDouble(),
        loggedAt: DateTime.parse(json['loggedAt']),
      );
}

class DailyMealPlan {
  final String id;
  final String title;
  final String breakfast;
  final String lunch;
  final String dinner;
  final String snacks;
  final int totalCalories;

  DailyMealPlan({
    required this.id,
    required this.title,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
    required this.totalCalories,
  });

  static List<DailyMealPlan> get samplePlans => [
        DailyMealPlan(
          id: 'mp_high_protein',
          title: 'High Protein Muscle Builder',
          breakfast: 'Oatmeal (60g) + 3 Scrambled Eggs + 1 Banana',
          lunch: 'Grilled Chicken Breast (200g) + Jasmine Rice (150g) + Broccoli',
          dinner: 'Atlantic Salmon (200g) + Baked Sweet Potato + Asparagus',
          snacks: 'Greek Yogurt (200g) + Whey Protein Shake + 15g Almonds',
          totalCalories: 2550,
        ),
        DailyMealPlan(
          id: 'mp_lean_shred',
          title: 'Lean Fat Loss Shred Plan',
          breakfast: 'Egg White Omelet (4 whites + 1 egg) + Spinach + 1 Slice Whole Wheat Toast',
          lunch: 'Turkey Breast Bowl (180g) + Brown Rice (100g) + Mixed Greens',
          dinner: 'White Fish Fillet (220g) + Zucchini Noodles + Olive Oil Drizzle',
          snacks: 'Protein Smoothie with Berries & Water + Apple',
          totalCalories: 1850,
        ),
      ];
}
